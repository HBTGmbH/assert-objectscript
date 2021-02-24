/// Description
Class hbt.utility.testing.AssertBuilder Extends %SystemBase
{

/// The test context necessary for asserts to work
Property TestContext As %UnitTest.TestCase;

ClassMethod AssertOnContext(testContext As %UnitTest.TestCase) As hbt.utility.testing.AssertBuilder
{
    Set instance = ##class(hbt.utility.testing.AssertBuilder).%New()
    Set instance.TestContext = testContext
    return instance
}

Method ThatActualArray(actual As %DynamicArray) As hbt.utility.testing.ArrayAssertBuilder
{
    Set builder = ##class(hbt.utility.testing.ArrayAssertBuilder).BuildInstance(..TestContext, actual)
    return builder
}

Method ThatActualObject(actual As %DynamicObject) As hbt.utility.testing.ObjectAssertBuilder
{
    Set builder = ##class(hbt.utility.testing.ObjectAssertBuilder).BuildInstance(..TestContext, actual)
    return builder
}

}
