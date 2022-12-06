/*
 * Copyright (C) 2006-2021  Music Technology Group - Universitat Pompeu Fabra
 *
 * This file is part of Essentia
 *
 * Essentia is free software: you can redistribute it and/or modify it under
 * the terms of the GNU Affero General Public License as published by the Free
 * Software Foundation (FSF), either version 3 of the License, or (at your
 * option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
 * details.
 *
 * You should have received a copy of the Affero GNU General Public License
 * version 3 along with this program.  If not, see http://www.gnu.org/licenses/
 */

#ifndef ESSENTIA_ROGUEVECTOR_H
#define ESSENTIA_ROGUEVECTOR_H

#include <vector>
#include "types.h"
#include "pool.h"

namespace {
    // This struct is different in every translation unit.  We use template
    // instantiations to define inline freestanding methods.  Since the
    // methods are inline it is fine to define them in multiple translation
    // units, but the instantiation itself would be an ODR violation if it is
    // present in the program more than once.  By tagging the instantiations
    // with this struct, we avoid ODR problems for the instantiation while
    // allowing the resulting methods to be inline-able.
    struct EssentiaVectorHackTranslationUnitTag {};
} // namespace

namespace essentia {


template <typename T>
class RogueVector : public std::vector<T> {
 protected:
  bool _ownsMemory;

 public:
  RogueVector(T* tab = 0, size_t size = 0) : std::vector<T>(), _ownsMemory(false) {
    setData(tab, size);
  }

  RogueVector(uint size, T value) : std::vector<T>(size, value), _ownsMemory(true) {}

  RogueVector(const RogueVector<T>& v) : std::vector<T>(), _ownsMemory(false) {
    setData(const_cast<T*>(v.data()), v.size());
  }

  ~RogueVector() {
    if (!_ownsMemory) {
      setData(0, 0);
    }
  }

  // Those need to be implementation specific
  void setData(T* data, size_t size);
};

// Clang/LLVM implementation
#if defined(__clang__) || defined(__EMSCRIPTEN__)

// TODO: this is a big hack that relies on clang/libcpp not changing the memory
//       layout of the std::vector (very dangerous, but works for now...)

template <typename T>
void RogueVector<T>::setData(T* data, size_t size) {
    *reinterpret_cast<T**>(this) = data;
    T** start = reinterpret_cast<T**>(this);
    *(start + 1) = *start + size;
    *(start + 2) = *start + size;
}

// Linux implementation
#elif defined(OS_LINUX) || defined(OS_MINGW)

template <typename T>
void RogueVector<T>::setData(T* data, size_t size) {
  this->_M_impl._M_start = data;
  this->_M_impl._M_finish = this->_M_impl._M_start + size;
  this->_M_impl._M_end_of_storage = this->_M_impl._M_start + size;
}

// Windows implementation
#elif defined(_MSC_VER) && _MSC_VER <= 1916
// MSVC <= VS2017

template <typename T>
void RogueVector<T>::setData(T* data, size_t size) {
  this->_Myfirst() = data;
  this->_Mylast() = this->_Myfirst() + size;
  this->_Myend() = this->_Myfirst() + size;
}

#elif defined(_MSC_VER) && _MSC_VER > 1916
// MSVC >= VS2019

// The following implementation is based on
// https://github.com/facebook/folly/blob/main/folly/memory/UninitializedMemoryHacks.h
//
// License:
//
// Copyright (c) Meta Platforms, Inc. and affiliates.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

namespace unsafe {

namespace detail {
  template <typename T>
  void set_data(std::vector<T>& v, T* data, std::size_t n);
} // namespace detail

template <typename T>
void set_vector_data(std::vector<T>& v, T* data, std::size_t n) {
    detail::set_data(v, data, n);
}
} // namespace unsafe

namespace unsafe {
namespace detail {

#define DECLARE_VECTOR_SET_DATA_IMPL(TYPE)                      \
  namespace unsafe {                                            \
  namespace detail {                                            \
  void set_data_impl(std::vector<TYPE>& v, TYPE*, std::size_t); \
  template <>                                                   \
  inline void set_data<TYPE>(                                   \
      std::vector<TYPE> & v, TYPE* data, std::size_t n) {       \
    set_data_impl(v, data, n);                                  \
  }                                                             \
  }                                                             \
  }

// For Microsoft's STL vector implementation (VS2019+), see
// https://github.com/microsoft/STL/blob/2f03bdf361f7f153b4216c60a0d9491c0be13a73/stl/inc/vector

template <
    typename Tag,
    typename T,
    typename A,
    A Ptr_Mypair,
    typename B,
    B Ptr_Myval2,
    typename C,
    C Ptr_Mylast,
    typename D,
    D Ptr_Myfirst,
    typename E,
    E Ptr_Myend>
struct VectorHack : std::vector<T> {
  friend void set_data_impl(std::vector<T>& v, T* data, std::size_t n) {
      ((v.*Ptr_Mypair).*Ptr_Myval2).*Ptr_Myfirst = data;
      ((v.*Ptr_Mypair).*Ptr_Myval2).*Ptr_Mylast = ((v.*Ptr_Mypair).*Ptr_Myval2).*Ptr_Myfirst + n;
      ((v.*Ptr_Mypair).*Ptr_Myval2).*Ptr_Myend = ((v.*Ptr_Mypair).*Ptr_Myval2).*Ptr_Myfirst + n;
  }
};

#define DECLARE_VECTOR_SET_DATA(TYPE)                                          \
  template struct unsafe::detail::VectorHack<                                  \
      EssentiaVectorHackTranslationUnitTag,                                    \
      TYPE,                                                                    \
      decltype(&std::vector<TYPE>::_Mypair),                                   \
      &std::vector<TYPE>::_Mypair,                                             \
      decltype(&decltype(std::declval<std::vector<TYPE>>()._Mypair)::_Myval2), \
      &decltype(std::declval<std::vector<TYPE>>()._Mypair)::_Myval2,           \
      decltype(&decltype(std::declval<std::vector<TYPE>>()                     \
                             ._Mypair._Myval2)::_Mylast),                      \
      &decltype(std::declval<std::vector<TYPE>>()._Mypair._Myval2)::_Mylast,   \
      decltype(&decltype(std::declval<std::vector<TYPE>>()                     \
                             ._Mypair._Myval2)::_Myfirst),                     \
      &decltype(std::declval<std::vector<TYPE>>()._Mypair._Myval2)::_Myfirst,  \
      decltype(&decltype(std::declval<std::vector<TYPE>>()                     \
                             ._Mypair._Myval2)::_Myend),                       \
      &decltype(std::declval<std::vector<TYPE>>()._Mypair._Myval2)::_Myend>;   \
  DECLARE_VECTOR_SET_DATA_IMPL(TYPE)                                           \

} // namespace detail
} // namespace unsafe

// The following list emerged by trial & error:

DECLARE_VECTOR_SET_DATA(int)
DECLARE_VECTOR_SET_DATA(float)
DECLARE_VECTOR_SET_DATA(Tuple2<float>)
DECLARE_VECTOR_SET_DATA(std::string)
DECLARE_VECTOR_SET_DATA(std::vector<int>)
DECLARE_VECTOR_SET_DATA(std::vector<float>)
DECLARE_VECTOR_SET_DATA(std::vector<std::complex<float>>)
DECLARE_VECTOR_SET_DATA(std::vector<std::vector<float>>)
DECLARE_VECTOR_SET_DATA(std::vector<std::vector<std::complex<float>>>)
DECLARE_VECTOR_SET_DATA(TNT::Array2D<Real>)
DECLARE_VECTOR_SET_DATA(Tensor<Real>)
DECLARE_VECTOR_SET_DATA(essentia::Pool)
// Only for testing (test_fileoutput.cpp)
DECLARE_VECTOR_SET_DATA(std::complex<float>)
DECLARE_VECTOR_SET_DATA(std::vector<std::string>)
DECLARE_VECTOR_SET_DATA(TNT::Array1D<Real>)

template <typename T>
void RogueVector<T>::setData(T* data, size_t size) {
    unsafe::set_vector_data<T>(*this, data, size);
}

#else

#warning "No implementation for RogueVector<T>"

#endif

} // namespace essentia

#endif // ESSENTIA_ROGUEVECTOR_H
