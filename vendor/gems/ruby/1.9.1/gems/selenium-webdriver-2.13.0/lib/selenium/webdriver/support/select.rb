module Selenium
  module WebDriver
    module Support
      class Select

        def initialize(element)
          tag_name = element.tag_name

          unless tag_name.downcase == "select"
            raise ArgumentError, "unexpected tag name #{tag_name.inspect}"
          end

          @element = element
          @multi   = ![nil, "false"].include?(element.attribute(:multiple))
        end

        #
        # Does this select element support selecting multiple options?
        #

        def multiple?
          @multi
        end

        #
        # Get all options for this select element
        #

        def options
          @element.find_elements :tag_name => "option"
        end

        #
        # Get all selected options for this select element
        #

        def selected_options
          options.select { |e| e.selected? }
        end

        #
        # Get the first selected option in this select element
        #

        def first_selected_option
          option = options.find { |e| e.selected? }
          option or raise Error::NoSuchElementError, 'no options are selected'
        end

        #
        # Select options by visible text, index or value.
        #

        def select(how, what)
          case how
          when :text, :index, :value
            raise NotImplementedError
          else
            raise ArgumentError, "can't select options by #{how.inspect}"
          end
        end

        # /**
        #  * Select all options that display text matching the argument. That is, when given "Bar" this
        #  * would select an option like:
        #  *
        #  * &lt;option value="foo"&gt;Bar&lt;/option&gt;
        #  *
        #  * @param text The visible text to match against
        #  */
        # public void selectByVisibleText(String text) {
        #   // try to find the option via XPATH ...
        #   List<WebElement> options =
        #       element.findElements(By.xpath(".//option[normalize-space(.) = " + escapeQuotes(text) + "]"));
        #
        #   boolean matched = false;
        #   for (WebElement option : options) {
        #     setSelected(option);
        #     if (!isMultiple()) {
        #       return;
        #     }
        #     matched = true;
        #   }
        #
        #   if (options.isEmpty() && text.contains(" ")) {
        #     String subStringWithoutSpace = getLongestSubstringWithoutSpace(text);
        #     List<WebElement> candidates;
        #     if ("".equals(subStringWithoutSpace)) {
        #       // hmm, text is either empty or contains only spaces - get all options ...
        #       candidates = element.findElements(By.tagName("option"));
        #     } else {
        #       // get candidates via XPATH ...
        #       candidates =
        #           element.findElements(By.xpath(".//option[contains(., " +
        #               escapeQuotes(subStringWithoutSpace) + ")]"));
        #     }
        #     for (WebElement option : candidates) {
        #       if (text.equals(option.getText())) {
        #         setSelected(option);
        #         if (!isMultiple()) {
        #           return;
        #         }
        #         matched = true;
        #       }
        #     }
        #   }
        #
        #   if (!matched) {
        #     throw new NoSuchElementException("Cannot locate element with text: " + text);
        #   }
        # }
        #
        # private String getLongestSubstringWithoutSpace(String s) {
        #   String result = "";
        #   StringTokenizer st = new StringTokenizer(s, " ");
        #   while (st.hasMoreTokens()) {
        #     String t = st.nextToken();
        #     if (t.length() > result.length()) {
        #       result = t;
        #     }
        #   }
        #   return result;
        # }
        #
        # /**
        #  * Select the option at the given index. This is done by examing the "index" attribute of an
        #  * element, and not merely by counting.
        #  *
        #  * @param index The option at this index will be selected
        #  */
        # public void selectByIndex(int index) {
        #   String match = String.valueOf(index);
        #
        #   boolean matched = false;
        #   for (WebElement option : getOptions()) {
        #     if (match.equals(option.getAttribute("index"))) {
        #       setSelected(option);
        #       if (!isMultiple()) {
        #         return;
        #       }
        #       matched = true;
        #     }
        #   }
        #   if (!matched) {
        #     throw new NoSuchElementException("Cannot locate option with index: " + index);
        #   }
        # }
        #
        # /**
        #  * Select all options that have a value matching the argument. That is, when given "foo" this
        #  * would select an option like:
        #  *
        #  * &lt;option value="foo"&gt;Bar&lt;/option&gt;
        #  *
        #  * @param value The value to match against
        #  */
        # public void selectByValue(String value) {
        #   StringBuilder builder = new StringBuilder(".//option[@value = ");
        #   builder.append(escapeQuotes(value));
        #   builder.append("]");
        #   List<WebElement> options = element.findElements(By.xpath(builder.toString()));
        #
        #   boolean matched = false;
        #   for (WebElement option : options) {
        #     setSelected(option);
        #     if (!isMultiple()) {
        #       return;
        #     }
        #     matched = true;
        #   }
        #
        #   if (!matched) {
        #     throw new NoSuchElementException("Cannot locate option with value: " + value);
        #   }
        # }
        #

        #
        # Clear all selected entries. Only valid if the element supports multiple selections.
        #

        def deselect_all
          unless multiple?
            raise Error::UnsupportedOperationError, 'you may only deselect all options of a multi-select'
          end
          
          options.each { |e| deselect_option e }
        end
        
        #
        # Deselect options by visible text, index or value.
        # 
        
        def deselect(how, what)
          case how
          when :value, :index, :text
            raise NotImplementedError
          else
            raise ArgumentError, "can't deselect options by #{how.inspect}"
          end
        end
        
        
        #
        # /**
        #  * Deselect all options that have a value matching the argument. That is, when given "foo" this
        #  * would deselect an option like:
        #  *
        #  * &lt;option value="foo"&gt;Bar&lt;/option&gt;
        #  *
        #  * @param value The value to match against
        #  */
        # public void deselectByValue(String value) {
        #   StringBuilder builder = new StringBuilder(".//option[@value = ");
        #   builder.append(escapeQuotes(value));
        #   builder.append("]");
        #   List<WebElement> options = element.findElements(By.xpath(builder.toString()));
        #   for (WebElement option : options) {
        #     if (option.isSelected()) {
        #       option.click();
        #     }
        #   }
        # }
        #
        # /**
        #  * Deselect the option at the given index. This is done by examing the "index" attribute of an
        #  * element, and not merely by counting.
        #  *
        #  * @param index The option at this index will be deselected
        #  */
        # public void deselectByIndex(int index) {
        #   String match = String.valueOf(index);
        #
        #   for (WebElement option : getOptions()) {
        #     if (match.equals(option.getAttribute("index")) && option.isSelected()) {
        #       option.click();
        #     }
        #   }
        # }
        #
        # /**
        #  * Deselect all options that display text matching the argument. That is, when given "Bar" this
        #  * would deselect an option like:
        #  *
        #  * &lt;option value="foo"&gt;Bar&lt;/option&gt;
        #  *
        #  * @param text The visible text to match against
        #  */
        # public void deselectByVisibleText(String text) {
        #   StringBuilder builder = new StringBuilder(".//option[normalize-space(.) = ");
        #   builder.append(escapeQuotes(text));
        #   builder.append("]");
        #   List<WebElement> options = element.findElements(By.xpath(builder.toString()));
        #   for (WebElement option : options) {
        #     if (option.isSelected()) {
        #       option.click();
        #     }
        #   }
        # }
        #
        # protected String escapeQuotes(String toEscape) {
        #   // Convert strings with both quotes and ticks into: foo'"bar -> concat("foo'", '"', "bar")
        #   if (toEscape.indexOf("\"") > -1 && toEscape.indexOf("'") > -1) {
        #     boolean quoteIsLast = false;
        #     if (toEscape.indexOf("\"") == toEscape.length() - 1) {
        #       quoteIsLast = true;
        #     }
        #     String[] substrings = toEscape.split("\"");
        #
        #     StringBuilder quoted = new StringBuilder("concat(");
        #     for (int i = 0; i < substrings.length; i++) {
        #       quoted.append("\"").append(substrings[i]).append("\"");
        #       quoted
        #           .append(((i == substrings.length - 1) ? (quoteIsLast ? ", '\"')" : ")") : ", '\"', "));
        #     }
        #     return quoted.toString();
        #   }
        #
        #   // Escape string with just a quote into being single quoted: f"oo -> 'f"oo'
        #   if (toEscape.indexOf("\"") > -1) {
        #     return String.format("'%s'", toEscape);
        #   }
        #
        #   // Otherwise return the quoted string
        #   return String.format("\"%s\"", toEscape);
        # }
        #
        
        private
        
        def select_option(opt)
          opt.click unless opt.selected?
        end
        
        def deselect_option(opt)
          opt.click if opt.selected?
        end

      end
    end
  end
end
