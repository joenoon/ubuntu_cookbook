class Chef
  class Node
    class Attribute
      def service_action_state
        if service_enabled?
          [ :enable, :start ]
        else
          [ :stop, :disable ]
        end
      end
      def service_enabled?
        if self[:enabled]
          true
        else
          false
        end
      end
    end
  end
end
