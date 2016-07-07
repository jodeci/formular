require 'formular/elements'
require 'formular/elements/modules/container'
require 'formular/elements/modules/wrapped_control'
module Formular
  module Elements
    module Foundation6
      module InputGroups
        module WrappedGroup
          include Formular::Elements::Module
          include Formular::Elements::Modules::WrappedControl

          def wrapper(&block)
            builder.fieldset(Attributes[options[:wrapper_options]], &block)
          end
        end

        class InputGroup < Formular::Elements::Input
          include WrappedGroup
          include Formular::Elements::Modules::Container

          tag :input
          set_default :class, :input_class # we need to do classes better...

          add_option_keys :left_label, :right_label, :left_button, :right_button

          html(:raw_input) { |input| input.closed_start_tag }

          html do |input|
            content = input.has_content? ? input.content : input.to_html(context: :with_options)
            Wrapper.(content: content)
          end

          def group_label(content = nil, option_key: nil)
            return '' unless content || option_key
            addon_content = content || options[option_key]
            return '' unless addon_content
            label_options = { content: addon_content }
            label_options[:class] = ['is-invalid-label'] if has_errors?

            Label.(label_options)
          end

          def group_button(content = nil, option_key: nil)
            return '' unless content || option_key
            addon_content = content || options[option_key]
            return '' unless addon_content

            Button.(content: addon_content)
          end

          def group_input
            to_html(context: :raw_input)
          end

          def input_class
            return ['input-group-field'] unless has_errors?

            ['input-group-field', 'is-invalid-input']
          end

          def label_options
            return super unless has_errors?

            @label_options ||= Attributes[options[:label_options]].merge(class: ['is-invalid-label'])
          end

          html(:with_options) do |input, output|
            output.concat input.group_label(option_key: :left_label)
            output.concat input.group_button(option_key: :left_button)
            output.concat input.group_input
            output.concat input.group_label(option_key: :right_label)
            output.concat input.group_button(option_key: :right_button)
          end
        end

        class Wrapper < Formular::Elements::Container
          tag :div
          set_default :class, ['input-group']
        end # class Wrapper

        class Label < Formular::Elements::Container
          tag :span
          set_default :class, ['input-group-label']
        end # class Label

        class Button < Formular::Elements::Container
          tag :div
          set_default :class, ['input-group-button']
        end # class Button
      end
    end
  end
end
