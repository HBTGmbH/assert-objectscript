## Assert-Objectscript


Assert-Objectscriptm is a supplemental assertion library meant to enhance readability of resulting test failures.

Instead of this
```ObjectScript
AssertEquals:objectA== objectB was '6@%Library.DynamicObject'
```

you will get this
```ObjectScript
AssertFailure:
    Expected:
%DynamicObject(value: Foo)
    to be equal to:
%DynamicObject(value: Bar)
```

## Limitations
Assert-Objectscript started out as an assertion library for dynamic objects and arrays. As such, it is mostly intended to work with these two categories of objects in Intersystems.

We designed this library in a way that it *should* work with almost any intersystems objects, excluding lists made with $listbuild. We would appreciate any form of feedback and also contributions to enhance this library to contain more assertions.

## Basic Usage

Assert-Objectscript uses a builder pattern to construct an assertion. It consists of these steps
1. Construct the assertion builder
2. Configure the assertion builder
3. Finish with an assertion

Each assert follows this in the fashion of ``assert...thatActual...is...``

### Construction
Since Assert-Objectscript relies on the basic ObjectScript asserts and the ``AssertFailureViaMacro`` function, a test context with the ``%UnitTest.TestCase`` class must be available. So you will start any assertion like this.

```ObjectScript
set builder = ##class(utility.testing.AssertBuilder).AssertOnContext($THIS)
```

From there on, you have the choice between an assert on an object or an array.

```ObjectScript
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
```ObjectScript
builder.ThatActualObject(actual).UsingFieldByFieldComparison().IsEqualTo(Exepcted)
```


## Available Assertions

All examples assume that this method exists to shorten
the actual assert. You could, of course, register a macro for that, too.
```ObjectScript
Method Assert() As utility.testing.AssertBuilder
{
    return ##class(utility.testing.AssertBuilder).AssertOnContext($THIS)
}
```

### Arrays

Check that an array has 2 elements
```ObjectScript
set array = ["A", "B"]
do ..Assert().ThatActualArray(array).HasSize(2)
```

Check that an array is empty
```ObjectScript
set array = []
do ..Assert().ThatActualArray(array).ToBeEmpty()
```

Check that an array is not empty
```ObjectScript
set array = ["A", "B"]
do ..Assert().ThatActualArray(array).NotToBeEmpty()
```

Check that an array contains a value
```ObjectScript
set array = ["A", "B"]
do ..Assert().ThatActualArray(array).ToContain("A")
```

Check that an array does not contain a value
```ObjectScript
set array = ["A", "B"]
do ..Assert().ThatActualArray(array).NotToContain("C")
```

Check that two arrays are equal
```ObjectScript
set arrayA = ["A", "B"]
set arrayB = ["A", "B"]
do ..Assert().ThatActualArray(arrayA).ToEqual(arrayB)
```

Check that two arrays contain the same elements, regardless of order
```ObjectScript
set arrayA = ["A", "B"]
set arrayB = ["B", "A"]
do ..Assert().ThatActualArray(arrayA).IgnoringOrder().ToEqual(arrayB)
```

### Objects

Check if an object is defined
```ObjectScript
do ..Assert().ThatActualObject(object).IsDefined()
```

Check if an object is not defined
```ObjectScript
do ..Assert().ThatActualObject(object).IsNotDefined()
```

Check if two objects are equal
```ObjectScript
set objectA = {"value": "ObjectScript Test"}
do ..Assert().ThatActualObject(objectA).IsEqualTo(objectA)
```

Check if two objects are equal while comparing their field values recursively
```ObjectScript
set objectA = {"value": "ObjectScript Test"}
set objectB = {"value": "ObjectScript Test"}
do ..Assert().ThatActualObject(objectA).IsEqualTo(objectB)
```

Check if two objects are equal while comparing their field values recursively
```ObjectScript
set objectA = {"value": "ObjectScript Test"}
set objectB = {"value": "ObjectScript Test"}
do ..Assert().ThatActualObject(objectA).UsingFieldByFieldComparison().IsEqualTo(objectB)
```

Check if two objects are equal while ignoring a given field
```ObjectScript
set objectA = {"value": "ObjectScript Test", "id": 1}
set objectB = {"value": "ObjectScript Test", "id": 2}
do ..Assert().ThatActualObject(objectA).UsingFieldByFieldComparison().IgnoringField("id").IsEqualTo(objectB)
```


