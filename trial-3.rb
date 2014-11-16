require 'unimidi'

$note_numbers = [62,64,65,67,69,71,72]
$note_lengths = [0.25, 0.25, 0.25, 1.25]
$duration = 0.75

class Note < Struct.new(:number, :time)
end

def next_note_index(last_index)
  case last_index
  when 0
    last_index += 1
  when 1..($note_numbers.length - 1) - 1
    last_index += [-1, 1].sample
  else
    last_index += -1
  end
  return last_index
end

UniMIDI::Output.gets do |output|
  begin
    srand(0)
    last_index = 0
    q = []
    q.push(Note.new(last_index, $note_lengths[-1]))

    loop do
      note = q.shift
      if note
        output.puts(0x90, $note_numbers[note.number], 100)
        sleep($duration * note.time)
        output.puts(0x80, $note_numbers[note.number], 100)
        sleep((1.0 - $duration) * note.time)
      else
        $note_lengths.each do |note_length|
          last_index = next_note_index(last_index)
          q.push(Note.new(last_index, note_length))
        end
      end
    end
  end
end
