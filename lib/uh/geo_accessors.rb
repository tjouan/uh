require 'forwardable'

module Uh
  module GeoAccessors
    extend Forwardable
    def_delegators :@geo,
      :x, :y, :width, :height,
      :x=, :y=, :width=, :height=
  end
end
