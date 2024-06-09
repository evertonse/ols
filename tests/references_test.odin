package tests

import "core:fmt"
import "core:testing"

import test "src:testing"

@(test)
reference_variables_in_function :: proc(t: ^testing.T) {
	source := test.Source {
		main     = `package test
		my_function :: proc() {
			a := 2
			b := a
			c := 2 + b{*}
		}
		`,
		packages = {},
	}

	test.expect_reference_locations(
		t,
		&source,
		{
			{
				range = {
					start = {line = 3, character = 3},
					end = {line = 3, character = 4},
				},
			},
			{
				range = {
					start = {line = 4, character = 12},
					end = {line = 4, character = 13},
				},
			},
		},
	)
}

@(test)
reference_variables_in_function_parameters :: proc(t: ^testing.T) {
	source := test.Source {
		main     = `package test
		my_function :: proc(a: int) {
			b := a{*}
		}
		`,
		packages = {},
	}

	test.expect_reference_locations(
		t,
		&source,
		{
			{
				range = {
					start = {line = 1, character = 22},
					end = {line = 1, character = 23},
				},
			},
		},
	)
}

@(test)
reference_selectors_in_function :: proc(t: ^testing.T) {
	source := test.Source {
		main     = `package test
		My_Struct :: struct {
			a: int,
		}

		my_function :: proc() {
			my: My_Struct
			my.a{*} = 2
		}
		`,
		packages = {},
	}

	test.expect_reference_locations(
		t,
		&source,
		{
			{
				range = {
					start = {line = 2, character = 3},
					end = {line = 2, character = 4},
				},
			},
			{
				range = {
					start = {line = 7, character = 6},
					end = {line = 7, character = 7},
				},
			},
		},
	)
}


@(test)
reference_field_comp_lit :: proc(t: ^testing.T) {
	source := test.Source {
		main     = `package test
		Foo :: struct {
			soo_many_cases: int,
		}

		My_Struct :: struct {
			foo: Foo,
		}

		my_function :: proc(my_struct: My_Struct) {
			my := My_Struct {
				foo = {soo_many_cases{*} = 2},
			}
		}
		`,
		packages = {},
	}

	test.expect_reference_locations(
		t,
		&source,
		{
			{
				range = {
					start = {line = 2, character = 3},
					end = {line = 2, character = 17},
				},
			},
			{
				range = {
					start = {line = 11, character = 11},
					end = {line = 11, character = 25},
				},
			},
		},
	)
}

@(test)
reference_field_comp_lit_infer_from_function :: proc(t: ^testing.T) {
	source := test.Source {
		main     = `package test
		Foo :: struct {
			soo_many_cases: int,
		}

		My_Struct :: struct {
			foo: Foo,
		}

		my_function :: proc(my_struct: My_Struct) {
			my_function({foo = {soo_many_cases{*} = 2}})
		}
		`,
		packages = {},
	}

	test.expect_reference_locations(
		t,
		&source,
		{
			{
				range = {
					start = {line = 2, character = 3},
					end = {line = 2, character = 17},
				},
			},
			{
				range = {
					start = {line = 10, character = 23},
					end = {line = 10, character = 37},
				},
			},
		},
	)
}
