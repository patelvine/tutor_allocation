module ApplicationHelper

    def active?(request_path, path)
      request_path == path
    end

    def active_controller?(request_controller, controller)
      request_controller == controller
    end

    def active_namespace?(request_controller, namespace)
      request_controller.class.name.split("::").first == namespace
    end

end
