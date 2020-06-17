package main

import "sort"

func TaintStepTest_SortReverse_B0I0O0(sourceCQL interface{}) interface{} {
	// The flow is from `fromInterface311` into `intoInterface535`.

	// Assume that `sourceCQL` has the underlying type of `fromInterface311`:
	fromInterface311 := sourceCQL.(sort.Interface)

	// Call the function that transfers the taint
	// from the parameter `fromInterface311` to result `intoInterface535`
	// (`intoInterface535` is now tainted).
	intoInterface535 := sort.Reverse(fromInterface311)

	// Return the tainted `intoInterface535`:
	return intoInterface535
}

func RunAllTaints_Sort() {
	{
		// Create a new source:
		source := newSource()
		// Run the taint scenario:
		out := TaintStepTest_SortReverse_B0I0O0(source)
		// If the taint step(s) succeeded, then `out` is tainted and will be sink-able here:
		sink(out)
	}
}
