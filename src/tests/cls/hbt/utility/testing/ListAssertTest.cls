Class hbt.utility.testing.ListAssertTest Extends %UnitTest.TestCase
{

/// Description
Method Assert() As %Status
{
    return ##class(hbt.utility.testing.AssertBuilder).AssertOnContext($THIS)
}

/// Description
Method TestShouldCompareListsForEquality() As %Status
{
    #; set listA = $listbuild("A", "B", "C")
    #; set listB = $listbuild("A", "B", "C")
    #; do ..Assert().ThatActualList(listA).isEqualTo(listB)
}

}
