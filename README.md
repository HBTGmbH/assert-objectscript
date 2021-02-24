# Assert Objectscript
Assert Objectscript is a supplemental assertion library meant to enhance readability of resulting test failures. 

Instead of this
```objectscript
AssertEquals:objectA== objectB was '6@%Library.DynamicObject'
```
you will get this
```objectscript
AssertFailure:
    Expected:
%DynamicObject(value: Foo)
    to be equal to:
%DynamicObject(value: Bar)
```
The goal of this library is to provide the developer with enough information to find the reason for a test failure without the need to debug the code.

# Installation
<TODO: Brief guide on how to use the ZPM package manager as soon as it's published>

# Usage
## General Usage
Assert-Objectscript uses a builder pattern to construct an assertion. It consists of these steps
1. Construct the assertion builder
2. Configure the assertion builder
3. Finish with an assertion

Each assert follows this in the fashion of ``assert...thatActual...isEqualTo``

### Construction
Since Assert-Objectscript relies on the basic ObjectScript asserts and the ``AssertFailureViaMacro`` function, a test context with the ``%UnitTest.TestCase`` class must be available. So you will start
any assertion like this.

```objectscript
set builder = ##class(hbt.utility.testing.AssertBuilder).AssertOnContext($THIS)
```

From there on, you have the choice between an assert on on object or array.

```objectscript
set arrayAssertBuilder = builder.ThatActualObject(object)
set objectAssertBuilder = builder.ThatActualArray(object)
```

### Configuraion
Once constructed, you can configure your assertion. For example, you could:
1. Use field by field comparison instead of object equality ``UsingFieldByFieldComparison()``
2. Ignore array order ``IgnoringOrder()``
3. Ignore a certain field during field by field comparsion ``IgnoringField("ID")``

### Assertion

Lastly, you need to finish with an assertion.
```objectscript
builder.ThatActualObject(actual).UsingFieldByFieldComparison().IsEqualTo(Exepcted)
```

### Overview of Assertions

All example assume that this method exists to shorten
the actual assert. You could, of course, register a macro for that, too.
```objectscript
Method Assert() As hbt.utility.testing.AssertBuilder
{
    return ##class(hbt.utility.testing.AssertBuilder).AssertOnContext($THIS)
}
```

| Description                                                                         | Code                                                                                        |
|-------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------|
| Check if an object is defined                                                       | ``do ..Assert().ThatActualObject(object).IsDefined()``                                      |
| Check if an object is `not defined                                                  | ``do ..Assert().ThatActualObject(object).IsNotDefined()``                                   |
| Check if two objects are equal                                                      | ``do ..Assert().ThatActualObject(objectA).IsEqualTo(objectB)``                              |
| Check if two objects are equal by comparing each field individually and recursively | ``do ..Assert().ThatActualObject(objectA).UsingFieldByFieldComparison()IsEqualTo(objectB)`` |


# Limitations and Planned Improvements
1. Currently only tested on dynamic objects and dynmaic arrays. Should work for normal objects and lists, too (to be tested)
2. Only works in context of UnitTest
3. Not many assertions implemented yet
4. badly formatted dynamic objects
5. badly formatted error messages (room for improvement here)
6. Assertions on basic types (%Integer, %String) not implemented yet