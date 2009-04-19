<?php
/*
	STOW_NAME=>DÇø(1300,1360)
*/
Class Stack{
	public $STOWid;
	public $STOW_NAME="";
	public $BOAT_NAME="";
	public $COUSTOMER_NAME="";
	public $COUSTOMER_NAME1="";
	public $GOODS_NAME="";

	var $_explicitType = "info.osmatrix.Team";
	
	public function toStr()
	{
		$str = $this->STOWid.":".$this->STOW_NAME.":".$this->BOAT_NAME.":".$this->COUSTOMER_NAME.":".$this->COUSTOMER_NAME1.":".$this->GOODS_NAME;;
		return $str;
	}
	
	public function tosvg()
	{
	

		$stackareastr = $this->STOW_NAME;
		$pos1 = strpos($stackareastr, '('); //echo $stackareastr . "=>pos1:".$pos1 . "----";
		$pos2 = strpos($stackareastr, ','); //echo $stackareastr . "=>pos2:".$pos2 . "----";
		$pos3 = strpos($stackareastr, ')'); //echo $stackareastr . "=>pos3:".$pos3 . "----";
		
		$area = mb_substr($stackareastr,1,1,"GB2312");
		$widthstart = trim(mb_substr($stackareastr,$pos1 , $pos2 - $pos1 - 1, "GB2312"));	
		$widthend = trim(mb_substr($stackareastr,$pos2 , $pos3 - $pos2 -1 , "GB2312"));
		//echo "area:".$area."width:" . $widthstart .", widthend:" . $widthend;
		
		$x = $widthstart * 100 / 5 ;$y = 0;
		$width = $widthend - $widthstart;
		//$height = 8;
		
		$svgelement = "<rect x='" . $x ."' y='".$y."' width='".$width."' height='8' "." STOWid='".$this->STOWid."' STOW_NAME='".$this->STOW_NAME."' BOAT_NAME='".$this->BOAT_NAME."' GOODS_NAME='".$this->GOODS_NAME."' COUSTOMER_NAME='".$this->COUSTOMER_NAME."' style='fill:#00FFFF;stroke:#000000;stroke-width:1' rx= '2' ry = '2' onclick='objectMouseClick(evt)' onmouseout='objectMouseOut(evt)' onmouseover='objectMouseOver(evt)' type='stack'/>";
		
		return $svgelement;
	}
}

?>