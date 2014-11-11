require 'unimidi'

q = []
note = 0
note_numbers = [62,64,65,67,69]
duration = 0.75

class Note < Struct.new(:number, :time)
end

table = [
  [
    [Note.new(1, 0.25), Note.new(0, 0.25), Note.new(1, 1.5)],
    [Note.new(1, 0.25), Note.new(2, 0.25), Note.new(1, 1.5)],
    [Note.new(1, 0.25), Note.new(2, 0.25), Note.new(3, 1.5)],
  ],
  [
    [Note.new(0, 0.25), Note.new(1, 0.25), Note.new(0, 1.5)],
    [Note.new(0, 0.25), Note.new(1, 0.25), Note.new(2, 1.5)],
    [Note.new(2, 0.25), Note.new(1, 0.25), Note.new(0, 1.5)],
    [Note.new(2, 0.25), Note.new(1, 0.25), Note.new(2, 1.5)],
    [Note.new(2, 0.25), Note.new(3, 0.25), Note.new(2, 1.5)],
    [Note.new(2, 0.25), Note.new(3, 0.25), Note.new(4, 1.5)],
  ],
  [
    [Note.new(1, 0.25), Note.new(0, 0.25), Note.new(1, 1.5)],
    [Note.new(1, 0.25), Note.new(2, 0.25), Note.new(1, 1.5)],
    [Note.new(1, 0.25), Note.new(2, 0.25), Note.new(3, 1.5)],
    [Note.new(3, 0.25), Note.new(2, 0.25), Note.new(1, 1.5)],
    [Note.new(3, 0.25), Note.new(2, 0.25), Note.new(3, 1.5)],
    [Note.new(3, 0.25), Note.new(4, 0.25), Note.new(3, 1.5)],
  ],
  [
    [Note.new(2, 0.25), Note.new(1, 0.25), Note.new(0, 1.5)],
    [Note.new(2, 0.25), Note.new(1, 0.25), Note.new(2, 1.5)],
    [Note.new(2, 0.25), Note.new(3, 0.25), Note.new(2, 1.5)],
    [Note.new(2, 0.25), Note.new(3, 0.25), Note.new(4, 1.5)],
    [Note.new(4, 0.25), Note.new(3, 0.25), Note.new(2, 1.5)],
    [Note.new(4, 0.25), Note.new(3, 0.25), Note.new(4, 1.5)],
  ],
  [
    [Note.new(3, 0.25), Note.new(2, 0.25), Note.new(1, 1.5)],
    [Note.new(3, 0.25), Note.new(2, 0.25), Note.new(3, 1.5)],
    [Note.new(3, 0.25), Note.new(4, 0.25), Note.new(3, 1.5)],
  ],
]

UniMIDI::Output.gets do |output|
  begin
    srand(0)
    current = 0
    q.push(Note.new(current, 1.5))

    loop do
      note = q.shift
      if note
        current = note.number
        output.puts(0x90, note_numbers[note.number], 100)
        sleep(duration * note.time)
        output.puts(0x80, note_numbers[note.number], 100)
        sleep((1.0 - duration) * note.time)
      else
        e = table[current].sample
        q.push(*e)
      end
    end
  end
end
