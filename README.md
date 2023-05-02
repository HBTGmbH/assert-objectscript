# Assert Objectscript
Assert Objectscript is a supplemental assertion library meant to enhance readability of resulting test failures. 

Instead of this
```objectscript
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
The goal of this library is to provide the developer with enough information to find the reason for a test failure without the need to debug the code.

# Installation
Assert-Objectscript is available in the [InterSystems Open Exchange](https://openexchange.intersystems.com/) and in the Open Exchange ZPM Registry.

To install Assert-Objectscript, open an IRIS session into your IRIS instance and run the following command in the namespace you need

```ObjectScript
zpm "install assert-objectscript"
```

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

```ObjectScript
set builder = ##class(utility.testing.AssertBuilder).AssertOnContext($THIS)
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

### Overview of Assertions

All example assume that this method exists to shorten
the actual assert. You could, of course, register a macro for that, too.
```ObjectScript
Method Assert() As utility.testing.AssertBuilder
{
    return ##class(utility.testing.AssertBuilder).AssertOnContext($THIS)
}
```

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

# Compiling and Building

To compile, build and upload to ZPM, follow these steps:

1. Start the compose instance ``docker-compose up -d``
2. Exec yourself into the container with an IRIS instance ``./open-iris-session.bat``(or ``./open-iris-session.sh`` on Linux)
3. Go to ZPM terminal ``zpm``
4. Load the source files into ZPM ``load /irisdev/app``
5. Verify the assert-obectscript package ``assert-objectscript package -v``
6. Set the registry to a ZPM registry ``repo -n registry -r -url <registry> -user <user> -pass <pass>`` (Make sure your registry url ends with a trailing /)
7. Publish the package ``assert-objectscript -v publish``


# Links
* [Describing a module with ZPM](https://community.intersystems.com/post/describing-modulexml-objectscript-package-manager)
* [Setting up your own ZPM registry](https://community.intersystems.com/post/setting-your-own-intersystems-objectscript-package-manager-registry)
* [AssertJ](https://assertj.github.io/doc/)

# For Developers
See [Contributing](./CONTRIBUTING.MD)

# Limitations and Planned Improvements
1. Currently only tested on dynamic objects, dynamic arrays and %SystemBase objects; Lists made with $listbuild are not supported yet
2. Only works in context of UnitTest
3. Not many assertions implemented yet
4. Formatting of dynamic objects needs improvement
5. Formatting of error messages in the IRIS test viewer needs improvement (optimized for console output)
6. Assertions on basic types (%Integer, %String) not implemented yet