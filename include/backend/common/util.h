#pragma once

#include <concepts>
#include <type_traits>

// GCC 15's libstdc++ does not treat __int128 as an integral type, so
// std::integral, std::make_unsigned, and std::is_signed reject it. Clang
// still accepts it. __int128 and unsigned __int128 are __int128_t and
// __uint128_t.
template <typename T>
concept extended_integral = std::same_as<std::remove_cv_t<T>, __int128> ||
                            std::same_as<std::remove_cv_t<T>, unsigned __int128>;

namespace orq {

template <typename T>
struct make_unsigned {
    using type = std::make_unsigned_t<T>;
};

template <extended_integral T>
struct make_unsigned<T> {
    using type = unsigned __int128;
};

template <typename T>
using make_unsigned_t = typename make_unsigned<T>::type;

template <typename T>
inline constexpr bool is_signed_v =
    std::is_signed_v<T> || std::same_as<std::remove_cv_t<T>, __int128>;

template <typename T>
inline constexpr bool is_unsigned_v =
    std::is_unsigned_v<T> || std::same_as<std::remove_cv_t<T>, unsigned __int128>;

}  // namespace orq

template <typename U, bool UseUnsigned = ((std::integral<U> || extended_integral<U>) &&
                                          !std::is_same_v<std::remove_cv_t<U>, bool>)>
struct UnsignedTypeSelector {
    using type = U;
};

template <typename U>
struct UnsignedTypeSelector<U, true> {
    using type = orq::make_unsigned_t<U>;
};
