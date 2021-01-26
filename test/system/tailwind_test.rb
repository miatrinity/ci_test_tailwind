require 'application_system_test_case'

class TailwindTest < ApplicationSystemTestCase
  TAILWIND_TEXT_RED_500 = 'rgb(239, 68, 68)'.freeze
  TAILWIND_TEXT_4XL = '2.55rem'.freeze

  test 'Tailwind is Enabled' do
    visit verify_index_path

    assert_selector 'h1', text: 'Hello, Tailwind!'
    assert_equal computed_color, expected_tailwind_color, 'Error: color not computed correctly'
    assert_equal computed_font_size, expected_tailwind_font_size, 'Error: font size not computed correctly'
  end

  private

  def computed_color
    computed_style_for(selector: 'h1', attribute: 'color')
  end

  def expected_tailwind_color
    TAILWIND_TEXT_RED_500
  end

  def computed_font_size
    computed_style_for(selector: 'h1', attribute: 'font-size')
  end

  def expected_tailwind_font_size
    font_size_in_pixels = (root_element_font_size.to_i * TAILWIND_TEXT_4XL.to_f).to_i
    "#{font_size_in_pixels}px"
  end

  def root_element_font_size
    computed_style_for(selector: 'html', attribute: 'font-size')
  end

  def computed_style_for(selector:, attribute:)
    evaluate_script("window.getComputedStyle(document.querySelector('#{selector}'))['#{attribute}']")
  end
end