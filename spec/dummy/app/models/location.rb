class Location < ApplicationRecord
  FIRST_QUADRANT = :first
  SECOND_QUADRANT = :second
  THIRD_QUADRANT = :third
  FOURTH_QUADRANT = :fourth
  ORIGIN = :origin
  X_AXIS = :x_axis
  Y_AXIS = :y_axis

  # @return [Integer]
  def quadrant # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
    if latitude.positive? && longitude.positive?
      FIRST_QUADRANT
    elsif latitude.positive? && longitude.negative?
      SECOND_QUADRANT
    elsif latitude.negative? && longitude.negative?
      THIRD_QUADRANT
    elsif latitude.negative? && longitude.positive?
      FOURTH_QUADRANT
    elsif latitude.zero? && longitude.zero?
      ORIGIN
    elsif latitude.zero?
      X_AXIS
    else
      Y_AXIS
    end
  end
end
