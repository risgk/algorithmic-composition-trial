$file = File::open("sample_midi_stream.bin", "wb")

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

srand(0)
current = 0
q.push(Note.new(current, 1.5))

(0..63).each do
  note = q.shift
  if note
    current = note.number
    $file.write([0x90, note_numbers[note.number], 100].pack("C*"))
    ((duration * note.time) * 4000).to_i.times { $file.write([0xFE].pack("C")) }
    $file.write([0x80, note_numbers[note.number], 100].pack("C*"))
    (((1.0 - duration) * note.time) * 4000).to_i.times { $file.write([0xFE].pack("C")) }
  else
    e = table[current].sample
    q.push(*e)
  end
end
