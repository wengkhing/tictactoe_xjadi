class Game < ActiveRecord::Base
  belongs_to :player1, class_name: 'User', foreign_key: 'player1_id'
  belongs_to :player2, class_name: 'User', foreign_key: 'player2_id'
  belongs_to :winner, class_name: 'User', foreign_key: 'winner_id'
  has_many :moves


  def status_string
    case status
    when 0
      "Waiting"
    when 1
      "Playing"
    when 2
      "Completed"
    end
  end
end
