require 'rspec'
require 'gis/distance'

RSpec.describe GIS::Distance do
  let(:gis){ GIS::Distance.new(40.47, 73.58, 34.3, 118.15) }

  example 'version' do
    expect(GIS::Distance::VERSION).to eq('1.1.0')
    expect(GIS::Distance::VERSION).to be_frozen
  end

  example 'distance basic functionality' do
    expect(gis).to respond_to(:distance)
    expect{ gis.distance }.not_to raise_error
    expect(gis.distance).to be_kind_of(Float)
  end

  example 'distance method returns expected result' do
    expect(gis.distance).to be_within(0.01).of(3952.39)
    expect(GIS::Distance.new(40.47, 73.58, 40.47, 73.58).distance).to eq(0.0)
  end

  example 'constructor requires four arguments' do
    expect{ GIS::Distance.new }.to raise_error(ArgumentError)
    expect{ GIS::Distance.new(40.47) }.to raise_error(ArgumentError)
    expect{ GIS::Distance.new(40.47, 73.58) }.to raise_error(ArgumentError)
    expect{ GIS::Distance.new(40.47, 73.58, 34.3) }.to raise_error(ArgumentError)
  end

  example 'latitude and longitude must be within range' do
    expect{ GIS::Distance.new(91.0, 100.0, 45.0, 45.0) }.to raise_error(GIS::Distance::Error)
    expect{ GIS::Distance.new(90.0, 190.0, 45.0, 45.0) }.to raise_error(GIS::Distance::Error)
  end

  example 'radius basic functionality' do
    expect(gis).to respond_to(:radius)
    expect{ gis.radius }.not_to raise_error
    expect( gis.radius).to be_kind_of(Float)
  end

  example 'default radius returns expected value' do
    expect(gis.radius).to eq(6367.45)
  end

  example 'radius does not accept an argument' do
    expect{ gis.radius(1) }.to raise_error(ArgumentError)
  end

  example 'radius setter basic functionality' do
    expect(gis).to respond_to(:radius=)
    expect{ gis.radius = 6368.0 }.not_to raise_error
    expect( gis.radius).to eq(6368.0)
  end

  example 'radius value must be within a certain range' do
    expect{ gis.radius = 6200 }.to raise_error(GIS::Distance::Error)
    expect{ gis.radius = 6400 }.to raise_error(GIS::Distance::Error)
  end

  example 'formula basic functionality' do
    expect(gis).to respond_to(:formula)
    expect{ gis.formula }.not_to raise_error
    expect(gis.formula).to be_kind_of(String)
  end

  example 'formula default value' do
    expect(gis.formula).to eq('haversine')
  end

  example 'formula setter basic functionality' do
    expect(gis).to respond_to(:formula=)
    expect{ gis.formula = 'haversine' }.not_to raise_error
  end

  example 'formula setter validates value' do
    expect{ gis.formula(1) }.to raise_error(ArgumentError)
    expect{ gis.formula = 'foo' }.to raise_error(GIS::Distance::Error)
  end

  example 'mi basic functionality' do
    expect(gis.distance).to respond_to(:mi)
    expect{ gis.distance.mi }.not_to raise_error
    expect(gis.distance.mi).to be_kind_of(Float)
  end

  example 'mi behaves as expected' do
    expect(gis.distance).to be > gis.distance.mi
    expect(gis.distance.mi).to be_within(0.1).of(2455.9)
  end

  example 'mi_expected_errors' do
    expect{ gis.distance.mi(1) }.to raise_error(ArgumentError)
  end
end
