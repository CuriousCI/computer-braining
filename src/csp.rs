// list of variables
// - variable: domain
// - arrays of variables
// - iperarchi
// - axum magic parttern to define constraints?
//
//
// a constraint is like a function, that given a value for x, a value for y returns either false or true
// NO, a constraint is a function that given a partial assignment returns either true or false

pub struct Assignment;

pub trait FromAssignment {
    fn from_assignment(assignment: &Assignment) -> Self;
}

pub trait Handler<T> {
    fn call(self, assignment: Assignment);
}

impl<F, T> Handler<T> for F
where
    F: Fn(T),
    T: FromAssignment,
{
    fn call(self, assignment: Assignment) {
        (self)(T::from_assignment(&assignment))
    }
}

impl<F, T1, T2> Handler<(T1, T2)> for F
where
    F: Fn(T1, T2),
    T1: FromAssignment,
    T2: FromAssignment,
{
    fn call(self, assignment: Assignment) {
        (self)(
            T1::from_assignment(&assignment),
            T2::from_assignment(&assignment),
        )
    }
}

pub fn trigger<T, H>(assignment: Assignment, handler: H)
where
    H: Handler<T>,
{
    handler.call(assignment);
}

pub struct CSP {}

impl CSP {
    pub fn new() -> Self {
        Self {}
    }
}

//let context = Context::new("magic".into(), 33);
//
//trigger(context.clone(), print_id);
