class InterludeSerializer < ActiveModel::Serializer
  attributes :id, :title, :lyrics, :done, :created_at, :updated_at

  def done
    # If the interlude is accessed through game_session_interlude, use that done status
    if instance_options[:game_session_interlude]
      instance_options[:game_session_interlude].done
    else
      object.done
    end
  end
end
