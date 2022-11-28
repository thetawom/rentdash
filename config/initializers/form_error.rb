ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  html = %(<div class="field_with_errors", style = "margin: 0px; padding: 0px">#{html_tag}</div>).html_safe
  # add nokogiri gem to Gemfile

  form_fields = %w[textarea input select numberfield]

  elements = Nokogiri::HTML::DocumentFragment.parse(html_tag).css "label, " + form_fields.join(', ')
  elements.each do |e|
    if e.node_name.eql? 'label'
      if instance.error_message.kind_of?(Array)
        html =  %(<div class="control-group error", style = "margin: 0px">#{html_tag}<br><span class="help-inline", style="color:red;">&nbsp;#{instance.error_message.uniq.join(', ')}</span></div>).html_safe
      
     end
    end
  end
  html
end