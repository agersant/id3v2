package format.id3v2;
import format.id3v2.Data.Frame;
import format.id3v2.Data.ParseError;
import haxe.io.Bytes;

/**
 * ...
 * @author agersant
 */

class TextInformationFrame extends Frame
{
	var values : Array<String>;
	public function new (data : Bytes)
	{
		super();
		
		var encoding : Int = data.get(0);
		if (encoding != 0 && encoding != 3)
			throw ParseError.UNSUPPORTED_TEXT_ENCODING;
		
		values = new Array();
		var stringStart = 1;
		var stringEnd = 1;
		while (stringStart < data.length)
		{
			if (stringEnd == data.length || data.get(stringEnd) == 0)
			{
				var value = data.getString(stringStart, stringEnd - stringStart);
				values.push(value);
				stringStart = stringEnd + 1;
				stringEnd = stringStart;
			}
			stringEnd++;
		}
	}
}

class FrameTALB extends TextInformationFrame {
	var album : Array<String>;
	public function new (data : Bytes)
	{
		super(data);
		album = values;
	}
}

class FrameTCON extends TextInformationFrame {
	var genre : Array<String>;
	public function new (data : Bytes)
	{
		super(data);
		genre = values;
	}
}

class FrameTIT2 extends TextInformationFrame {
	var title : Array<String>;
	public function new (data : Bytes)
	{
		super(data);
		title = values;
	}
}

class FrameTPE1 extends TextInformationFrame {
	var artist : Array<String>;
	public function new (data : Bytes)
	{
		super(data);
		artist = values;
	}
}

class FrameTXXX extends TextInformationFrame {
	var description : String;
	var value : String;
	public function new (data : Bytes)
	{
		super(data);
		description = values[0];
		value = values[1];
	}
}
 
class FrameTRCK extends TextInformationFrame
{

	var trackNumber : Int;
	var tracksInSet : Null<Int>;
	
	public function new (data : Bytes)
	{
		super(data);
		var text = values[0];
		
		var trackNumberRegex = ~/^[0-9]+/;
		if (trackNumberRegex.match(text))
		{
			trackNumber = Std.parseInt(trackNumberRegex.matched(0));
		}
		else
		{
			throw ParseError.INVALID_FRAME_DATA_TRCK;
		}
		
		var tracksInSetRegex = ~/\/([0-9]+)$/ ;
		if (tracksInSetRegex.match(text))
		{
			tracksInSet = Std.parseInt(tracksInSetRegex.matched(1));
		}
		else
		{
			tracksInSet = null;
		}
	}
	
}