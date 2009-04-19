//****************************************************************************
//Copyright © 2005-2006. Adobe Macromedia Software LLC. All rights reserved.
//The following Code is subject to all restrictions 
//contained in the End User License Agreement accompanying
//this product.
//****************************************************************************

/*
	It is the responsibility of the writer to add the state to the 
	string as opaque data using an encoding that only allows URL-safe 
	characters and consumes no more than 3.5K and is maximally compact (size matters). 
	
	For URL-safeness, current implementations use the following alphabet:
	"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_-$.!*+~"

	the interpretation of the data is up to the client
*/
interface MMQuizzingV3.MMSlideClasses.IQuizState
{
	public function getReadPos():Number;
	public function setReadPos(newPos:Number);
	
	public function getWritePos():Number;
	public function setWritePos(newPos:Number);
	
	public function getData():String;
	public function setData(newData:String);
};
