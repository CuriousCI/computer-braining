use crate::encoder::*;
use serde::Serialize;

#[derive(Clone, Copy, Hash, PartialEq, Eq, PartialOrd, Ord, Serialize, Debug)]
pub struct X(usize, usize);

pub fn encode_instance(
    addresses: usize,
    buses: &[(usize, usize)],
    vips: &[usize],
) -> (String, Vec<X>) {
    use Literal::Neg;
    // clients non ha "casa"
    let steps = addresses;

    let mut encoder = EncoderSAT::new();

    // ALO_ind
    for p in 1..=steps {
        encoder.add((2..=addresses + 1).map(|i| X(i, p).into()).collect())
    }

    // AMO_ind
    for p in 1..=steps {
        for i1 in 2..=addresses + 1 {
            for i2 in i1 + 2..addresses + 1 {
                encoder.add(vec![Neg(X(i1, p)), Neg(X(i2, p))])
            }
        }
    }

    // ALO_pass
    for i in 2..=addresses + 1 {
        encoder.add((1..=steps).map(|p| X(i, p).into()).collect());
    }

    // AMO_pass
    for i in 2..=addresses + 1 {
        for p1 in 1..=steps {
            for p2 in p1 + 1..=steps {
                encoder.add(vec![Neg(X(i, p1)), Neg(X(i, p2))]);
            }
        }
    }

    // casa_1
    for i in 2..=addresses + 1 {
        if !buses.contains(&(1, i)) {
            encoder.add(vec![Neg(X(i, 1))]);
        }
    }

    // casa_2
    for i in 2..=addresses + 1 {
        if !buses.contains(&(i, 1)) {
            encoder.add(vec![Neg(X(i, steps))]);
        }
    }

    // bus
    for p in 1..steps {
        for i in 2..=addresses + 1 {
            for j in 2..=addresses + 1 {
                if !buses.contains(&(i, j)) {
                    encoder.add(vec![Neg(X(i, p)), Neg(X(j, p + 1))]);
                }
            }
        }
    }

    // VIP
    for &v in vips {
        for p in steps.div_ceil(2) + 1..=steps {
            encoder.add(vec![Neg(X(v, p))]);
        }
    }

    encoder.end()
}
