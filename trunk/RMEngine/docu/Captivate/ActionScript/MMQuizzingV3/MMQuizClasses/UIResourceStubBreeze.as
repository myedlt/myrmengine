//****************************************************************************
//Copyright © 2005-2006. Adobe Macromedia Software LLC. All rights reserved.
//The following Code is subject to all restrictions 
//contained in the End User License Agreement accompanying
//this product.
//****************************************************************************

#include "StdImports.asi"

import Poolpah.Resource.UIResource;

class MMQuizzingV3.MMQuizClasses.UIResourceStub {
	function UIResourceStub() {
	}

	public static function findAndUseUIR(mc:MovieClip):Void
	{
		if (typeof(UIResource.findAndUseUIR) == "function")
			UIResource.findAndUseUIR(mc);
	}
}
