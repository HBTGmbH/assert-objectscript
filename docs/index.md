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

In general, it *should* work with almost any intersystems objects, excluding lists made with $listbuild. We would appreciate any form of feedback and also contributions to enhance this library to contain more assertions.

## Basic Usage

Assert-Objectscript uses a builder pattern to construct an assertion. It consists of these steps
1. Construct the assertion builder
2. Configure the assertion builder
3. Finish with an assertion

Each assert follows this in the fashion of ``assert...thatActual...is...``

### Construction
Since Assert-Objectscript relies on the basic ObjectScript asserts and the ``AssertFailureViaMacro`` function, a test context with the ``%UnitTest.TestCase`` class must be available. So you will start any assertion like this.

```ObjectScript
set builder = ##class(hbt.utility.testing.AssertBuilder).AssertOnContext($THIS)
```

From there on, you have the choice between an assert on on object or array.

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
### Dynamic Objects
### Dynamic Arrays
### Objects
### Lists

