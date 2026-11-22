#pragma once

#include <concepts>
#include <type_traits>

// GCC 15's libstdc++ does not treat __int128 as std::integral. Clang does.
// These are the same types as __int128_t and __uint128_t.
template <typename T>
concept extended_integral = std::same_as<std::remove_cv_t<T>, __int128> ||
                            std::same_as<std::remove_cv_t<T>, unsigned __int128>;

template <typename U, bool UseUnsigned = ((std::integral<U> || extended_integral<U>) &&
                                          !std::is_same_v<std::remove_cv_t<U>, bool>)>
struct UnsignedTypeSelector {
    using type = U;
};

template <typename U>
struct UnsignedTypeSelector<U, true> {
    using type = std::make_unsigned_t<U>;
};