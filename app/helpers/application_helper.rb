# frozen_string_literal: true

# Generic helper for app views.
module ApplicationHelper
  def submit_text
    { 'new' => 'Create', 'create' => 'Create', 'update' => 'Update', 'edit' => 'Update' }.fetch(action_name)
  end

  def turbo_flash_messages
    turbo_stream.replace 'flash_messages' do
      render partial: 'shared/flash_messages'
    end
  end

  def link(title, path)
    link_to title, path, class: 'text-purple-500', data: { turbo_action: 'advance' }
  end

  def submit_class
    %w[shadow
       bg-purple-500
       hover:bg-purple-400
       focus:shadow-outline
       focus:outline-none
       text-white
       font-bold
       py-2
       px-4
       rounded].join(' ')
  end

  # rubocop:disable Metrics/ParameterLists
  def button(title, path, color: 'blue', classes: [], confirm: nil, method: nil)
    classes_with_defaults = [button_class(color:)] + classes
    link_to title, path, class: classes_with_defaults.join(' '),
                         data: { turbo_action: 'advance', turbo_method: method, turbo_confirm: confirm }
  end
  # rubocop:enable Metrics/ParameterLists

  def button_class(color:)
    "bg-#{color}-600 hover:bg-blue-700 mr-1 text-base align-middle text-white font-bold py-2 px-4 rounded inline-block"
  end

  def h1(content, &block)
    tag.h1 class: 'font-medium leading-tight text-4xl mt-0 mb-2' do
      concat(content)
      concat(block.call) if block_given?
    end
  end

  def label_class
    'block uppercase tracking-wide text-gray-300 text-xs font-bold mb-2'
  end

  def input_defaults
    'bg-gray-700 text-gray-300 border rounded focus:outline-none'
  end

  # rubocop:disable Metrics/MethodLength
  def input_class
    classes = %w[
      appearance-none
      block
      w-full
      focus:text-gray-600
      px-4
      py-3
      mb-3
      leading-tight
      border-purple-500
      focus:bg-white
    ]
    "#{input_defaults} #{classes.join(' ')}"
  end
  # rubocop:enable Metrics/MethodLength

  def info_class
    'text-gray-400 text-xs italic'
  end

  def error_class
    'text-red-600 text-xs italic'
  end
end
