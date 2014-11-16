$outputBin = false
$outputBin = true if ARGV.length == 1

if $outputBin
  $file = File::open("sample_midi_stream.bin", "wb")
elsif
  require 'unimidi'
end

$note_numbers = [64, 65, 67, 69, 71, 72, 74]
$note_lengths = [1.0, 0.5, 0.25, 0.25]
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

def main_loop
  if $outputBin
    (0..63).each do
        yield
    end
  else
    UniMIDI::Output.gets do |output|
      loop do
        yield(output)
      end
    end
  end
end

def play(note, output)
  if $outputBin
    $file.write([0x90, $note_numbers[note.number], 100].pack("C*"))
    (($duration * note.time) * 4000).to_i.times { $file.write([0xFE].pack("C")) }
    $file.write([0x80, $note_numbers[note.number], 100].pack("C*"))
    (((1.0 - $duration) * note.time) * 4000).to_i.times { $file.write([0xFE].pack("C")) }
  elsif
    output.puts(0x90, $note_numbers[note.number], 100)
    sleep($duration * note.time)
    output.puts(0x80, $note_numbers[note.number], 100)
    sleep((1.0 - $duration) * note.time)
  end
end

srand(0)
last_index = 0
q = []

main_loop do |output|
  note = q.shift
  if note
    play(note, output)
  else
    $note_lengths.each do |note_length|
      last_index = next_note_index(last_index)
      q.push(Note.new(last_index, note_length))
    end
  end
end
