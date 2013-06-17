module EntriesHelper
  def refresh_url(options = {})
    url_for(refresh_options(options)).html_safe
  end
  
  def refresh_options(options = {})
    request_params = params.dup
    # get rid of jquery cache busting and stuff
    %w{ _ controller action utf8 commit count }.each do |item|
      request_params.delete(item)
    end
    request_params.merge(options)
  end
  
  def sanitize_entry(content)
    whitelist = HTML::Pipeline::SanitizationFilter::WHITELIST.merge({
      :elements => %w(
        h1 h2 h3 h4 h5 h6 h7 h8 br b i strong em a pre code img tt
        div ins del sup sub p ol ul table blockquote dl dt dd
        kbd q samp var hr ruby rt rp li tr td th iframe
      ),
      :attributes => {
        'a' => ['href', 'class'],
        'p' => ['class'],
        'img' => ['src', 'class', 'alt', 'title'],
        'div' => ['itemscope', 'itemtype', 'class'],
        'iframe' => ['src', 'style'],
        :all  => ['abbr', 'accept', 'accept-charset',
                  'accesskey', 'action', 'align', 'alt', 'axis',
                  'border', 'cellpadding', 'cellspacing', 'char',
                  'charoff', 'charset', 'checked', 'cite',
                  'clear', 'cols', 'colspan', 'color',
                  'compact', 'coords', 'datetime', 'dir',
                  'disabled', 'enctype', 'for', 'frame',
                  'headers', 'height', 'hreflang',
                  'hspace', 'ismap', 'label', 'lang',
                  'longdesc', 'maxlength', 'media', 'method',
                  'multiple', 'name', 'nohref', 'noshade',
                  'nowrap', 'prompt', 'readonly', 'rel', 'rev',
                  'rows', 'rowspan', 'rules', 'scope',
                  'selected', 'shape', 'size', 'span',
                  'start', 'summary', 'tabindex', 'target',
                  'title', 'type', 'usemap', 'valign', 'value',
                  'vspace', 'itemprop']
      },
      :protocols => {
        'a'   => {'href' => ['http', 'https', 'mailto']},
        'img' => {'src'  => ['http', 'https']},
        'iframe' => { 'src' => ['http', 'https'] }        
      }
    })
    
    pipeline = HTML::Pipeline.new [
      HTML::Pipeline::SanitizationFilter
      ], { whitelist: whitelist }
    
    pipeline.call(content)[:output].to_s
  end
end
