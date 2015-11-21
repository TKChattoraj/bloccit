class Labeling < ActiveRecord::Base
  belongs_to :labelable, polymorphic: true
  belongs_to :label
end

#
# Label
#   id: 1
#   name: 'outdoors'
# Label
#   id: 2
#   name: 'gear'
#
# Labeling
#   id: 1
#   label_id: 1
#   post_id: 1
# Labeling
#   id: 2
#   label_id: 1
#   post_id: 2
# Labeling
#   id: 3
#   label_id: 2
#   post_id: 1
# Labeling
#   id: 4
#   label_id: 2
#   post_id: 1
#
# Post
#   id: 1
#   title: 'Hiking'
# Post
#   id: 2
#   title: 'Camping'
# Post
#   id: 3
#   title: 'Watching TV'
