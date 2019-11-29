//
// Created by david on 2019-03-04.
//

#ifndef H5PP_TYPECOMPLEX_H
#define H5PP_TYPECOMPLEX_H


namespace h5pp{
    namespace Type{
        namespace Complex{
            inline hid_t H5T_COMPLEX_INT;
            inline hid_t H5T_COMPLEX_LONG;
            inline hid_t H5T_COMPLEX_UINT;
            inline hid_t H5T_COMPLEX_ULONG;
            inline hid_t H5T_COMPLEX_DOUBLE;
            inline hid_t H5T_COMPLEX_FLOAT;

            inline hid_t H5T_SCALAR2_INT;
            inline hid_t H5T_SCALAR2_LONG;
            inline hid_t H5T_SCALAR2_UINT;
            inline hid_t H5T_SCALAR2_ULONG;
            inline hid_t H5T_SCALAR2_DOUBLE;
            inline hid_t H5T_SCALAR2_FLOAT;

            template <typename T>
            struct H5T_COMPLEX_STRUCT {
                T real;   /*real part*/
                T imag;   /*imaginary part*/
                using value_type = T;
                using Scalar = T;
                H5T_COMPLEX_STRUCT() = default;
                explicit H5T_COMPLEX_STRUCT(const std::complex<T> &in){
                    real = in.real();
                    imag = in.imag();
                }
                H5T_COMPLEX_STRUCT & operator=(const std::complex<T> & rhs){
                    real = rhs.real();
                    imag = rhs.imag();
                    return *this;
                }
            };

            template <typename T>
            struct H5T_SCALAR2 {
                T x;
                T y;
                using value_type = double;
                using Scalar = double;
                H5T_SCALAR2() = default;
                template<typename Scalar2Type>
                explicit H5T_SCALAR2(const Scalar2Type &in){
                    static_assert(std::is_same_v<T, decltype(in.x)>);
                    static_assert(std::is_same_v<T, decltype(in.y)>);
                    x = in.x;
                    y = in.y;
                }
                template<typename Scalar2Type>
                H5T_SCALAR2 & operator=(const Scalar2Type & rhs){
                    static_assert(std::is_same_v<T, decltype(rhs.x)>);
                    static_assert(std::is_same_v<T, decltype(rhs.y)>);
                    x = rhs.x;
                    y = rhs.y;
                    return *this;
                }
            };

        }

    }

}



#endif //H5PP_H5PPTYPECOMPLEX_H
