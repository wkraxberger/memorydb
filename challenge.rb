class MemoryDB

  def initialize
    @values = {}
    @transaction_blocks = []
  end

  def get(key)
    puts @values[key]
  end

  def set(key, value)
    if @transaction_blocks.size > 0
      @transaction_blocks.last << [key, @values[key]]
    end

    @values[key] = value
  end

  def unset(key)
    set(key, nil)
  end

  def numequalto(value)
    puts @values.count { |k,v| v == value}
  end

  def commit
    @transaction_blocks = []
  end

  def begin
    @transaction_blocks << []
  end

  def rollback
    if @transaction_blocks.size.zero?
      puts "No transaction!" 
    else
      commands = @transaction_blocks.pop

      commands.reverse.each do |c|
        @values[c.first] = c.last
      end
    end
  end

  def method_missing(*args)
    puts "Invalid command"
  end
end

puts "Welcome to memory DB"

memory_db = MemoryDB.new

loop do
  print "> "

  args = gets.chomp.split(" ")
  command = args.shift.to_s.downcase

  break if command == "end"

  memory_db.send(command, *args)
end

puts "Thanks for using memory DB!"
