require 'spec_helper'

describe Zxcvbn::Score do
  subject { described_class.new }

  describe '#bruteforce_cardinality' do
    context 'when empty password' do
      it 'should return 0 if empty password' do
        subject.bruteforce_cardinality('').should eql 0
      end
    end

    context 'when password is one character long' do
      context 'and a digit' do
        it 'should return 10' do
          (0..9).each do |digit|
            subject.bruteforce_cardinality(digit.to_s).should eql 10
          end
        end
      end

      context 'and an upper case character' do
        it 'should return 26' do
          ('A'..'Z').each do |character|
            subject.bruteforce_cardinality(character).should eql 26
          end
        end
      end

      context 'and a lower case character' do
        it 'should return 26' do
          ('a'..'z').each do |character|
            subject.bruteforce_cardinality(character).should eql 26
          end
        end
      end

      context 'and a symbol' do
        it 'should return 33' do
          %w|/ [ ` {|.each do |symbol|
            subject.bruteforce_cardinality(symbol).should eql 33
          end
        end
      end
    end

    context 'when password is more than one character long' do
      context 'and only digits' do
        it 'should return 10' do
          subject.bruteforce_cardinality('123456789').should eql 10
        end
      end

      context 'and only lowercase characters' do
        it 'should return 26' do
          subject.bruteforce_cardinality('password').should eql 26
        end
      end

      context 'and only uppercase characters' do
        it 'should return 26' do
          subject.bruteforce_cardinality('PASSWORD').should eql 26
        end
      end

      context 'and only symbols' do
        it 'should return 33' do
          subject.bruteforce_cardinality('/ [ ` {').should eql 33
        end
      end

      context 'and a mixed of character types' do
        it 'should add up every character type cardinality' do
          subject.bruteforce_cardinality('p1SsWorD!').should eql 95
        end
      end
    end
  end

  describe '#display_time' do
    let(:minute_to_seconds)  { 60 }
    let(:hour_to_seconds)    { minute_to_seconds * 60 }
    let(:day_to_seconds)     { hour_to_seconds * 24 }
    let(:month_to_seconds)   { day_to_seconds * 31 }
    let(:year_to_seconds)    { month_to_seconds * 12 }
    let(:century_to_seconds) { year_to_seconds * 100 }

    context 'when less than a minute' do
      it 'should return instant' do
        [0, minute_to_seconds - 1].each do |seconds|
          subject.display_time(seconds).should eql 'instant'
        end
      end
    end

    context 'when less than an hour' do
      it 'should return a readable time in minutes' do
        [60, (hour_to_seconds - 1)].each do |seconds|
          subject.display_time(seconds).should =~ /[0-9]+ minutes$/
        end
      end
    end

    context 'when less than a day' do
      it 'should return a readable time in hours' do
        [hour_to_seconds, (day_to_seconds - 1)].each do |seconds|
          subject.display_time(seconds).should =~ /[0-9]+ hours$/
        end
      end
    end

    context 'when less than 31 days' do
      it 'should return a readable time in days' do
        [day_to_seconds, month_to_seconds - 1].each do |seconds|
          subject.display_time(seconds).should =~ /[0-9]+ days$/
        end
      end
    end

    context 'when less than 1 year' do
      it 'should return a readable time in days' do
        [month_to_seconds, (year_to_seconds - 1)].each do |seconds|
          subject.display_time(seconds).should =~ /[0-9]+ months$/
        end
      end
    end

    context 'when less than a century' do
      it 'should return a readable time in days' do
        [year_to_seconds, (century_to_seconds - 1)].each do |seconds|
          subject.display_time(seconds).should =~ /[0-9]+ years$/
        end
      end
    end

    context 'when a century or more' do
      it 'should return centuries' do
        subject.display_time(century_to_seconds).should eql 'centuries'
      end
    end
  end
end