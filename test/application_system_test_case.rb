require 'test_helper'

Capybara.server = :puma, { Silent: true }

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase

  class << self
    def setup_ci_chrome
      driven_by :selenium,
                using: :chrome,
                screen_size: [1920, 1080],
                options: { url: ENV['SELENIUM_URL'],
                           args: ['--headless', '--no-sandbox'] }
      # Make the test app listen to outside requests, for the remote Selenium instance.
      Capybara.server_host = '0.0.0.0'
    end

    def setup_local_chrome
      if ENV['SHOW_BROWSER']
        driven_by :selenium_chrome
      else
        driven_by :selenium, using: :headless_chrome, screen_size: [1920, 1080]
      end
    end
  end

  if ENV['SELENIUM_URL']
    setup_ci_chrome
  else
    setup_local_chrome
  end

  setup do
    if ENV['SELENIUM_URL']
      # Get the application container's IP
      ip = Socket.ip_address_list.detect(&:ipv4_private?).ip_address
      puts "**** docker ps ****"
      puts "*"*100      
      puts `docker ps`
      puts "*"*100
      # Use the IP instead of localhost so Capybara knows where to direct Selenium
      Capybara.app_host = "http://#{ip}:#{Capybara.server_port}"
      #host! "http://#{ip}:#{Capybara.server_port}"
    end
  end
end