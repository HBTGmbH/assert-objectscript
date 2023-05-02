/// Description
Class utility.testing.AssertBuilder Extends %SystemBase
{

/// The test context necessary for asserts to work
Property TestContext As %UnitTest.TestCase;

ClassMethod AssertOnContext(testContext As %UnitTest.TestCase) As utility.testing.AssertBuilder
{
    Set instance = ##class(utility.testing.AssertBuilder).%New()
    Set instance.TestContext = testContext
    return instance
}

Method ThatActualArray(actual As %DynamicArray) As utility.testing.ArrayAssertBuilder
{
    Set builder = ##class(utility.testing.ArrayAssertBuilder).BuildInstance(..TestContext, actual)
    return builder
}

Method ThatActualObject(actual As %DynamicObject) As utility.testing.ObjectAssertBuilder
{
    Set builder = ##class(utility.testing.ObjectAssertBuilder).BuildInstance(..TestContext, actual)
    return builder
}

/// Description
Method ThatActualList(actual As %SystemBase) As %Status
{
    Set sc = $$$OK
    // do something
    Return sc
}

}
