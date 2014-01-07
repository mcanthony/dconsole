package pgr.gconsole;

import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.TextEvent;
import flash.Lib;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFieldType;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import haxe.macro.Format;
import pgr.gconsole.GCThemes.Theme;


/**
 * 
 * @author TiagoLr ( ~~~ProG4mr~~~ )
 */

class GCInterface extends Sprite
{
	private var _bg:Sprite;
	private var _height:Int;
	private var _promptBg:Sprite;
	private var _monitorBg:Sprite;
	private var _border:Sprite;
	private var _promptFontYOffset:Int;
	private var _width:Int;
	private var _yOffset:Int;
	private var _carret:MovieClip;
	
	public var theme:GCThemes.Theme;
	public var txtConsole:TextField;
	public var txtPrompt:TextField;
	public var txtMonitorLeft:TextField;
	public var txtMonitorRight:TextField;
	
	var inited:Bool = false;
	var margin:Int = 0;
	
	public function new(height:Float, align:String, _Theme:GCThemes.Theme) {
		
		super();
		
		_width = Lib.current.stage.stageWidth;
		_height = Std.int(Lib.current.stage.stageHeight * height);
		align == "DOWN" ? _yOffset = Lib.current.stage.stageHeight - _height : _yOffset = 0;
		_Theme == null ? theme = GCThemes.DARK : theme = _Theme;
		
		createMonitor();
		
		_bg = new Sprite();
		addChild(_bg);
		
		_promptBg = new Sprite();
		addChild(_promptBg);
		
		_border = new Sprite();
		addChild(_border);
		
		txtPrompt = new TextField();
		txtPrompt.type = TextFieldType.INPUT;
		txtPrompt.selectable = true;
		txtPrompt.multiline = false;
		txtPrompt.alpha = theme.CON_TXT_A;
		setPromptFont();
		addChild(txtPrompt);
		
		txtConsole = new TextField();
		txtConsole.selectable = false;
		txtConsole.multiline = true;
		txtConsole.wordWrap = true;
		txtConsole.alpha = theme.CON_TXT_A;
		setConsoleFont();
		addChild(txtConsole);
		#if flash
		txtConsole.mouseWheelEnabled = true;
		#end
		
		_carret = new MovieClip();
		addChild(_carret);
		
		drawUI();
		resizeTextFields();
		
	}
	
	
	private function createMonitor()
	{
		_monitorBg = new Sprite();
		_monitorBg.graphics.beginFill(theme.MON_C, theme.MON_A);
		_monitorBg.graphics.drawRect(0, 0, Lib.current.stage.stageWidth, Lib.current.stage.stageHeight);
		_monitorBg.graphics.endFill();
		addChild(_monitorBg);	
		
		txtMonitorLeft = new TextField();
		txtMonitorLeft.selectable = false;
		txtMonitorLeft.multiline = true;
		txtMonitorLeft.alpha = theme.MON_TXT_A;
		txtMonitorLeft.x = 0;
		txtMonitorLeft.width = _width / 2;
		txtMonitorLeft.height = _height;
		addChild(txtMonitorLeft);
		
		txtMonitorRight = new TextField();
		txtMonitorRight.selectable = false;
		txtMonitorRight.multiline = true;
		txtMonitorRight.alpha = theme.MON_TXT_A;
		txtMonitorRight.x = _width / 2;
		txtMonitorRight.width = _width / 2;
		txtMonitorRight.height = _height;
		addChild(txtMonitorRight);
		
		setMonitorFont();
	}
	
	public function setConsoleFont(font:String = null, embed:Bool = false, size:Int = 14, bold:Bool = false, italic:Bool = false, underline:Bool = false )
	{
		if (font == null) font = "Consolas";
		embed ? txtConsole.embedFonts = true : txtConsole.embedFonts = false;
		txtConsole.defaultTextFormat = new TextFormat(font, size, theme.CON_TXT_C, bold, italic, underline, '', '', TextFormatAlign.LEFT, margin, margin);
		if (inited) // Update graphics.
		{
			drawUI();
			resizeTextFields();
		}
	}
	
	public function setPromptFont(font:String = null, embed:Bool = false, size:Int = 16, bold:Bool = false, ?italic:Bool = false, underline:Bool = false )
	{
		if (font == null) font = "Consolas";
		embed ? txtPrompt.embedFonts = true : txtPrompt.embedFonts = false;
		txtPrompt.defaultTextFormat = new TextFormat(font, size, theme.PRM_TXT_C, bold, italic, underline, '', '' , TextFormatAlign.LEFT);
		if (inited) // Update graphics.
		{
			drawUI();
			resizeTextFields();	
		}
	}
	
	public function setMonitorFont(font:String = null, embed:Bool = false, size:Int = 14, bold:Bool = false, ?italic:Bool = false, underline:Bool = false )
	{
		if (font == null) font = "Consolas";
		embed ? txtMonitorLeft.embedFonts = true : txtMonitorLeft.embedFonts = false;
		embed ? txtMonitorRight.embedFonts = true : txtMonitorRight.embedFonts = false;
		txtMonitorLeft.defaultTextFormat = new TextFormat(font, size, theme.MON_TXT_C, bold, italic, underline, '', '', TextFormatAlign.LEFT, 10,10);
		txtMonitorRight.defaultTextFormat = new TextFormat(font, size, theme.MON_TXT_C, bold, italic, underline, '', '', TextFormatAlign.LEFT, 10,10);
	}
	
	public function drawUI() 
	{	
		// draw console background.
		_bg.graphics.clear();
		_bg.graphics.beginFill(theme.CON_C, 1);
		_bg.graphics.drawRect(0, 0, _width, _height);
		_bg.graphics.endFill();
		_bg.y = _yOffset;
		_bg.alpha = theme.CON_A;
		// draw text input field.
		_promptBg.graphics.clear();
		_promptBg.graphics.beginFill(theme.PRM_C);
		_promptBg.graphics.drawRect(0, 0, _width, txtPrompt.textHeight);
		_promptBg.graphics.endFill();
		_promptBg.y = _height - txtPrompt.textHeight + _yOffset;
		_promptBg.alpha = theme.CON_A;
		// draw border.
		//_border.graphics.clear();
		//_border.graphics.lineStyle(1, 0xCCCCCC);
		//_border.graphics.moveTo(0, 0);
		//_border.graphics.lineTo(_width, 0);
		//_border.graphics.lineStyle(1, 0x666666);
		//_border.graphics.moveTo(0, 1);
		//_border.graphics.lineTo(_width, 1);
		//_border.alpha = theme.CON_A;
		
		if (_yOffset == 0) { // ALIGN UP
			_border.y = _promptBg.y + txtPrompt.textHeight + 2;
			_border.scaleY = -1;
		} else { // ALIGN DONW
			_border.y = _bg.y - 2;
		}
	}
	
	private function resizeTextFields() 
	{
		if (txtConsole == null || txtPrompt == null) return;
		
		txtConsole.x = 0;
		txtConsole.y = 0 + _yOffset;
		txtConsole.width = _width;
		txtConsole.height = _height - txtPrompt.textHeight + 2;
		
		txtPrompt.x = 0;
		txtPrompt.y = _height - txtPrompt.textHeight + _yOffset - 2; // -2 just for the good look.
		txtPrompt.autoSize = TextFieldAutoSize.LEFT;
		txtPrompt.height = 32;
		
		#if (cpp || neko)	// BUGFIX
		// fix margins bug.
		txtConsole.x += 10;
		txtConsole.width -= 10;
		txtPrompt.x += 10;
		txtPrompt.width -= 10;
		// fix bad starting font bug.
		txtPrompt.text = '';
		#end
	}
	public function toggleMonitor(turnOn:Bool) 
	{	
		_monitorBg.visible		= turnOn;
		txtMonitorLeft.visible	= turnOn;
		txtMonitorRight.visible	= turnOn;
	}
	
	public function toggleConsoleOn(turnOn:Bool) 
	{
		_bg.visible 	 	= turnOn;
		_promptBg.visible	= turnOn;
		_border.visible		= turnOn;
		txtConsole.visible	= turnOn;
		txtPrompt.visible	= turnOn;
	}

}