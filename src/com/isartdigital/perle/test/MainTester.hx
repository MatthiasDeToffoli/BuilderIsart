package com.isartdigital.perle.test;
import haxe.unit.TestRunner;

/**
 * I'm not sure how unit testing could be usefull for this project, huum.
 * @author ambroise
 */
class MainTester{

    static function main (){
        var r = new TestRunner();
        r.add(new TestTuto());
        // your can add others TestCase here
        // finally, run the tests
        r.run();
    }
	
}