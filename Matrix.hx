package net.whyville.haxe.util;




class Matrix 
{
	public var _cols : Int;
	public var _rows : Int;
	public var _cells : Array<Fraction>;
	
	public function new(row : Int, col : Int) // stores in an array a mtrix initialized at 0 for each cell.
	{
		_cells = new Array();
		_cols = col;
		_rows = row;
		for ( i in 0...row)
		{
			for (j in 0...col)
			{
				_cells [i*col + j]= new Fraction(0,1);
				//trace ("col " + j);
			}
			//trace ("row " + i);
		}
	}

	public function get_cell(row_i :Int , col_j : Int) : Fraction  //for this the row starts at 0 and so does the column
	{
		return _cells[row_i *_cols + col_j];
	}

	public function set_cell(row_i : Int, col_j : Int , fraction : Fraction) : Void
	{
		_cells[row_i*_cols + col_j] = fraction;
	}
	

	public function get_col(col : Int) : Array<Fraction> //the column numbers start at 0
	{
		var coll : Array<Fraction> = new Array();
		for ( i in 0..._rows)
		{
			coll[i] = _cells [ i*_cols + col];
		}

		return coll;
	}

	public function get_row(row: Int) : Array <Fraction>
	{
		var roww : Array<Fraction> = new Array();
		for ( j in 0..._cols)
		{
			roww[j] = _cells [ row*_cols + j];
		}

		return roww;
	}

	public function replace_col ( col : Int , arr : Array<Fraction>) // Only works if you provide an array of the correct length.
	{
		if (arr.length != _rows) return; 
		for (i in 0..._rows)
		{
			_cells[i*_cols + col] = arr[i];
		}
	}

	public function replace_row ( row : Int , arr : Array<Fraction>)
	{
		if (arr.length != _cols) return;
		for (j in 0..._cols)
		{
			_cells[row*_cols + j] = arr[j];
		}
	}
	 

	public function flip_column ( col1 : Int, col2: Int) : Void
	{
		var temp = get_col(col1);
		for (i in 0..._rows)
		{
			_cells[i*_cols + col1] = _cells[i*_cols +col2];
			_cells[i*_cols +col2] = temp[i];
		}
	}

	public function flip_row ( row1 : Int, row2: Int) : Void
	{
		var temp = get_row(row1);
		for (i in 0..._cols)
		{
			_cells[row1*_cols + i] = _cells[row2*_cols +i];
			_cells[row2*_cols +i] = temp[i];
		}
	}

	public function multiply_row(row : Int, coeff : Fraction) :Void
	{		
		for (i in 0..._cols)
		{
			_cells[row*_cols + i].multiply(coeff);
		}
	}

	public function linear_comb ( row1 : Int, row2 : Int, coeff : Fraction) : Void
	{	
		var temp : Fraction = new Fraction(0,1);
		for (i in 0..._cols)
		{
			temp._numerator = _cells[row2*_cols +i]._numerator;
			temp._denominator = _cells[row2*_cols +i]._denominator;
			temp.multiply(coeff);
			//trace ( "num : " + temp._numerator + " den: " + temp._denominator);
			//trace ( "num : " + _cells[row1*_cols + i]._numerator + " den: " + _cells[row1*_cols + i]._denominator);
			_cells[row1*_cols + i].add( temp);
			//trace ( "num : " + _cells[row1*_cols + i]._numerator + " den: " + _cells[row1*_cols + i]._denominator);
			
		}
	}

	public function triangularize () :Void     // only used to solve a system ... otherwise some issue might happen
	{	
		var inv : Fraction = new Fraction(0,1);
		for (i in 0..._rows)
		{	
			inv = place_pivot(i);
			if (inv._numerator==0) return;
			multiply_row(i, inv);
			for (j in (i+1)..._rows)
			{
				inv._numerator = _cells[j*_cols + i]._numerator;
				inv._denominator = _cells[j*_cols+i]._denominator;
				inv.multiply( new Fraction(-1,1));
				
				linear_comb( j , i , inv);
			}
			
		}
	}

	public function place_pivot( index : Int) : Fraction //return 0/1 if there is no more pivot to be found .... only used to solve systems.
	{
		var pivot : Fraction = new Fraction(0,1);
		for (i in index..._rows)
		{
			for (j in index..._cols-1)
			{
				if (_cells[i*_cols + j ]._numerator != 0)
				{
					if (i > index) flip_row( index , i);
					if (j > index) flip_column ( index , j);
					pivot._denominator = _cells[index*_cols+index]._numerator;
					pivot._numerator = _cells[index*_cols+index]._denominator;
					if (pivot._denominator <0)
					{
						pivot._denominator *= -1;
						pivot._numerator *= -1;
					}
					return pivot;
				}
			}
		}
		return pivot;		
	}

}
