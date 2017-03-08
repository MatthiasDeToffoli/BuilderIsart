package com.isartdigital.perle.test;

import haxe.unit.TestCase;

/**
 * http://old.haxe.org/doc/cross/unit
 * https://haxe.org/manual/std-unit-testing.html
 * @author ambroise
 */
class TestTuto extends TestCase{

	private var str:String;
	
	/**
	 * setup is called before each test runs (that mean each function here)
	 */
	override public function setup () {
        str = "foo";
    }
	
	public function testSetup () {
		trace("testSetup");
        assertEquals("foo", str);
    }
	
	public function testBasic () {
		trace("testBasic");
        assertEquals( "A", "A" );
    }
	
	/**
	 * Won't be called whittout "test" in function name
	 */
	public function trysomething () {
		trace("trysomething");
		assertFalse(5 > 1);
	}
	
	public function testArray () {
		trace("testArray");
		var actual = [1, 2, 3];
		// "[1, 2, 3]" won't work :)
		assertEquals("[1,2,3]", Std.string(actual));
	}
	
	/**
	 * tearDown is called once after all tests are run
	 * (actually it's called after each function)
	 */
	override public function tearDown ():Void {
		trace("tearDown");
	}
	
}