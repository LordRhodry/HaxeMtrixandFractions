package net.whyville.haxe.util;




class Fraction
{	
	public var _numerator : Int;
	public var _denominator : Int;

	public function new(num : Int , den : Int)
	{
		_numerator = num;
		_denominator = den;
	}
	
	public function gcf( a :Int , b: Int ) : Int
	{
		if (a <0) a= -1*a;
		if (b <0) b = -1 *b;
		var temp : Int = 0;
		while ( b >0)
		{	
			temp = b;
			b = a % b;
			a = temp;
		}
		return a;
	}


	public function simplify () : Void
	{
		var cur_gcf = gcf ( _numerator , _denominator );

		_numerator = Std.int(_numerator / cur_gcf);
		_denominator = Std.int( _denominator / cur_gcf); 
	}

	public function multiply ( a : Fraction ) : Void
	{
		_numerator *= a._numerator;
		_denominator *= a._denominator;
		simplify();   //we don't necessarily need to simplify but if we do not the size of the integer might eventually exceed teh limits)
	}
	
	public function add ( fraction : Fraction) : Void
	{
		var num : Int = fraction._numerator;
		var den : Int = fraction._denominator;
		//var temp_num = _numerator;
		var temp_den = _denominator;
		_numerator = _numerator * den;
		_denominator = _denominator * den;
		num = num * temp_den;
		_numerator += num;
		simplify(); //we don't necessarily need to simplify but if we do not the size of the integer might eventually exceed teh limits)
	}
}
