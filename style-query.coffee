
absurd = Absurd()

baseUnits =
   zIndex:     ''
   fontWeight: ''
   flexGrow:   ''
   flexShrink: ''

cssValue = (k, v) -> switch
   when 0 is v then '0'
   when __.isNumber v then String(v) + (if k of baseUnits then baseUnits[k] else 'px')
   else v

cssDefaults = (obj) ->
   return obj unless __.isObject obj
   __.keys(obj).forEach (k) ->
      obj[k] = if __.isObject ok = obj[k] then cssDefaults ok else cssValue k, ok
   obj


class StyleQuery
   constructor: (selector) ->
      @selector = selector
      @rules = @style = null
      selector and [0..(sheets = document.styleSheets).length - 1].forEach (i) =>
         sheets?[i]?.cssRules? and [0..(rules = sheets[i].cssRules).length - 1].forEach (j) =>
            if rules[j] and rules[j].selectorText == selector
               @rules = rules[j]
               @style = rules[j].style
   get: (property)        -> @style[property]
   set: (property, value) ->
      if __.isObject property then __.eachKeys property, (k) => @set k, property[k]
      else
         value = __.cssValue property, value
         property = __.dasherize property
         if value is '' then (@style[property] and @style.removeProperty property)
         else @style.setProperty(property, value)
      @

removeRule = (selector, property) ->
   [0..(sheets = document.styleSheets).length - 1].forEach (i) ->
      sheets?[i]?.cssRules? and [0..(rules = sheets[i].cssRules).length - 1].forEach (j) ->
         if rules[j] and rules[j].selectorText == selector
            if __.isArray(property)
               property.map (p) -> rules[j].style.removeProperty p
            else
               rules[j].style.removeProperty property
insertRule  = (rule, index = 0) ->
   #console.log window.cube.stylesheet
   if window.cube.stylesheet.insertRule then window.cube.stylesheet.insertRule rule, index else window.cube.stylesheet.addRule rule

removeMultipleRules = (obj) ->
   __.isObject(obj) and __.keys(obj).forEach (k) ->
      if __.isArray obj[k] then obj[k].forEach (p) -> __.removeRule k, p
      else __.removeRule k, obj[k]


#cube.style = document.createElement 'style'
#cube.style.setAttribute 'styleId', 'cube'

styleId = 'style-query-generated'

insertCss = (css) ->
   not __.isElement(document.getElementById styleId) and document.getElementsByTagName('head')[0].appendChild(
      do ->
         style = document.createElement "style"
         style.setAttribute "id", styleId
         style.setAttribute "type", "text/css"
         style
   )
   document.getElementById(styleId).appendChild document.createTextNode css

window.style$ = (selector) -> switch
   when __.isObject selector
      css = absurd.add(cssDefaults selector).compile()
      if not __.isElement idFound = document.getElementById styleId
         if __.hasDOMLoaded() then insertCss css
         else document.addEventListener "load", (event) -> insertCss css
      else idFound.appendChild document.createTextNode css
      ###
      if __.isEmpty style = $ '#' + styleId then $ ($) ->
         __.isEmpty($ '#' + styleId) and $('head').append '<style styleId="' + styleId + '" type="text/css"></style>'
         $('#' + styleId).append css
      else style.append css
      ###
      new StyleQuery()
   when __.isFunction selector then new StyleQuery selector()
   when __.isString selector   then new StyleQuery selector
