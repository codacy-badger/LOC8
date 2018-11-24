
![cover](https://user-images.githubusercontent.com/6648552/34352047-24a21748-ea5b-11e7-8bb4-e3b2a5297d92.png)

![Vesion](https://img.shields.io/badge/vesion-0.0.1-157575.svg)
![Swift vesion](https://img.shields.io/badge/swift-4.2-orange.svg)
![Xcode vesion](https://img.shields.io/badge/xcode-10.1-blue.svg)
![Platforms](https://img.shields.io/badge/platforms-iOS|macOS-lightgray.svg)
[![Build Status](https://travis-ci.com/Marwan-Al-Masri/LOC8.svg?token=H9CZx6r8wEAXyxtfxAbz&branch=master)](https://travis-ci.com/Marwan-Al-Masri/LOC8)
[![Code review Badge](https://api.codacy.com/project/badge/Grade/487a286297ef436d8284fa4e1b4dbf17)](https://www.codacy.com?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=Marwan-Al-Masri/LOC8&amp;utm_campaign=Badge_Grade)
![Documentation](./docs/badge.svg)
[![Test coverage](https://codecov.io/gh/Marwan-Al-Masri/LOC8/branch/master/graph/badge.svg?token=g1kcxuoSG6)](https://codecov.io/gh/Marwan-Al-Masri/LOC8)


<!-- ![Vesion](https://img.shields.io/badge/vesion-0.0.1-4B8A88.svg?style=for-the-badge&colorA=4B8A88&colorB=666666&logo=data%3Aimage%2Fpng%3Bbase64%2CiVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAQAAAC1%2BjfqAAABEElEQVQoz32RsUoDQRCG%2F3hHStsk9oKNRrG28x0sjcXlwEqEmGCVE2xkBYsEco2FYOH5DDlRsNeLvbnUeQY%2Fi927nI1bzew%2FO%2F%2FON5IkiRq%2BKgefWjVdkyRahBgMIc3V7UqOyEmZEJOSMywV24pnMtplx10yEmstPIkrPpx0zJmLPokkfOudsyPhs87DzzcbkkSb3P5FdEndqwknhDy67IXABreMJAb0WXLHDXPOGUiMMLbAMJbos%2BSaCy455Z2exLgo6PIqccB9OUVCR%2BKtsGixYIsjtiXq1CUO6bDJgqbsIETMHGAPz0JnxlDCL0AlZOyVFvt88aQCYwX1lJiYKfMK6so2GgQYDAGNP%2FL%2F6%2F4F%2FzfGPZcqU20AAAAASUVORK5CYII%3D)
![Swift](https://img.shields.io/badge/swift-4.0-orange.svg?style=for-the-badge&colorA=F27E3F&colorB=666666&logo=data%3Aimage%2Fpng%3Bbase64%2CiVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAQAAAC1%2BjfqAAAAyklEQVQoz63PPS9EURSF4Z0wGIkKxSQaOoUpadUkFNRCK3qt0E6inN8wrULr4w%2BoNCTiMjKJTuIrJplHc%2B84F43EW%2B21zpudfSL%2BjjHDv9WVZG6aLj%2BOR5hX6%2Bc1mclUGLVjRMNsnqs%2BnJZ3TDlWd2E1z1dYLisL7ux6tm8gwiVa389c0XWNczPecP%2FzJxt64AW8FvVEomzqKugU5bpDc%2Fk8aK8vPKgWyraetjMnnqQcfK1ekilz49FteuCQLUcy79paFiNUNOIf%2BARyG7AZEbNDrwAAAABJRU5ErkJggg%3D%3D)
![Xcode](https://img.shields.io/badge/xcode-9.2-blue.svg?style=for-the-badge&colorA=007EC6&colorB=666666&logo=data%3Aimage%2Fpng%3Bbase64%2CiVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAMAAAAoLQ9TAAAAeFBMVEUAAAD%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FGqOSsAAAAJ3RSTlMAAQIDBAUGBwwONj1CR01OT1JWYGdxiJeboKGirrDHycvW2t%2Fx9PV63T6GAAAAbklEQVR42n2LyRKCUAwEOyQquKEiKO57%2Fv8PLbGKl%2FJgnzKZHjpU1YxfMu1PWexPu2WK5PNx495O4qp4VJvbp%2FwyojlAjqTVZcYgZaO%2BgoTeXkcMkrD2MjwEuT8LJAilt3GRcfYpSmC1HfIfDf4bfu0EO9MjlBsAAAAASUVORK5CYII%3D)
![Platforms](https://img.shields.io/badge/platforms-iOS%20%7C%20macOS-lightgray.svg?style=for-the-badge&colorA=bbbbbb&colorB=666666&logo=data%3Aimage%2Fpng%3Bbase64%2CiVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAMAAAAoLQ9TAAAAvVBMVEUAAAD%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F6%2Bvr%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2B%2Fv7%2F%2F%2F%2F%2B%2Fv7%2F%2F%2F%2FWsUcWAAAAPXRSTlMAAQIDBAUNFRcbHyYqLjA1ODg5O0JDTlRZXWVrbW5ygYSOkpaYo6uvsLLDycvN0ezv8PP19vf5%2Bvv8%2Ff7%2BWnDe8QAAAKdJREFUeNo9jtcWwjAMQxUIe%2B%2B9994QoOj%2FPwu7LehBJ7pxHCGQARpd%2FBW1MfQ5Qyy8NWJZXpMwUc0RIFOLV1bVfNloMLBTx8Nysic3JSEGU%2FJNkUd2dCTn0X1ezj0fHEGXtOio%2BngswQpoCwhfFHxQ54sq4QO%2FQvoYEPFbU7LBnI%2FfyCUF2VuU49PJN3cOEVEyZKitDapifN4NeovTOq09fJKwEIPmL3YMHFpcYhZKAAAAAElFTkSuQmCC)

[![Build Status](https://img.shields.io/badge/Build-Passing-brightgreen.svg?style=for-the-badge&logo=data%3Aimage%2Fpng%3Bbase64%2CiVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAQAAAC1%2BjfqAAABO0lEQVQoz03RvUvVARjF8XOv9QcENQhF5FxtNYRLCG1Fv4roZSmjSQlbWgy5l6gwawuClgq3CEQaFLwRtoSktV10s8FeXCotpFvwafD%2B8p7x%2BT6cw3OeJEmiK0kcdMoJ%2B5NENVtSTRwwo9RrRzvxtsQxv7Gopm4RDGyStpVx37GkUFjChje6y%2Bjoc9MceOIZ%2FvrqtqLEI%2B3kDYyq29KU7Um8woo1LPuEj5r4gT%2B6kxjz2ahxYz4Y9NI79wzpsaK5GdGv5W7ikLNOGla4mNjpl0tJ7ND0zblEzSMP3DfoYeKMOaeT6DVkwrxrRszYo8e0G4a9MOVIWdVxs646bFJDw4LrrnjrTqIalSTR8NTz%2F%2Bf91LJuX6IrKomKx2204D1oKdpVp%2FS4bNoXNXWrbtlVzjtWEntdcN7uznf%2FAwm0MQFPK%2BzJAAAAAElFTkSuQmCC)](https://travis-ci.com/Marwan-Al-Masri/LOC8)
[![Codacy Badge](https://img.shields.io/badge/Review-B-brightgreen.svg?style=for-the-badge&logo=data%3Aimage%2Fpng%3Bbase64%2CiVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAQAAAC1%2BjfqAAABP0lEQVQoFQXBMW%2BNUQAG4Od8996WRtOGgdoY%2FAAGkVQ6skpsjeFOYuxChIT0JzTXTzBaiIjYTEINRCPSoYPUoE2kQjS93zmv50FKCuwcq5P2IvPbs%2F1qTpKSghSod7JC20lyfLqStN1%2BDCnSUR8k%2BUZ%2Fqz6lHydJUtdJQT9Okvbp7xKQMr2S90lS7yKnspu0jz%2FmyCBdCmzNtA9tr7%2BJejtJji6TESmQGXI2s6SULNZr5fRgAwDIsPRZzsNs2xwBAEAG1EnSPncXnyd1QjoAAD36YQ7sZxMFABTyxW%2Ff7c3Dr0UyTAEyIgvw5wymy%2B1re%2Fe4IyUDUqC9aVvTq6DeT%2BoGWQI4vNBeJ0ldB%2Bn6Gxxdyn5e1kf0q0mS1CcgBeifJUny80SuJzmo9yAFKRlyeL6utVftbRYyV9f%2BnYN0%2FAcnmtIFYDjQTgAAAABJRU5ErkJggg%3D%3D)](https://www.codacy.com?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=Marwan-Al-Masri/LOC8&amp;utm_campaign=Badge_Grade)
![Documentation](https://img.shields.io/badge/Documentation-69%25-yellowgreen.svg?style=for-the-badge&logo=data%3Aimage%2Fpng%3Bbase64%2CiVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAQAAAC1%2BjfqAAAA%2FElEQVQoz6XRvyvtARzG8ef7PadMBoNylR8puqNJkZIBR0nZDgaDu5mO5dQtgxJl8LNkIKUsuuPNv2CzGW5Z7iL%2FxcvgpBNl8Xymp%2BfTp573J%2FmOlIov48%2F7pVKl5aqJXl1RqLQHiUKpI9Ht2VT7hWk1NbWW%2B%2BGvR5PRb8mIPkNWzJizZlSPJXem%2FLYY0%2F459OTBjXUbLtz778VlYt9CdCr99EfVrgMnzpXOLNtyZNd8lImGX4lzx87cJCYcJbYx%2BVZn1nVi0IBBw4k9m0ni1FgSRWLHrYampoZLV6rt9YokMW5VXd2q2RaN4p2l4iPzT5gTFdXWVL580Ue9AlYOqADjyNOVAAAAAElFTkSuQmCC) [![CodeCov](https://img.shields.io/badge/Coverage-25%25-red.svg?style=for-the-badge&logo=data%3Aimage%2Fpng%3Bbase64%2CiVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAMAAAAoLQ9TAAAAsVBMVEUAAAD%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2B%2Fv7%2F%2F%2F%2F%2F%2F%2F%2FKPm31AAAAOnRSTlMAAQIDBAUGBxkiJCUpKjlAQlFVWlxeX2BhY2RlZmhub3F1eXp7ipGUqaqtrrq7zdHr7Pb4%2Bfr7%2FP7%2BoAjp1AAAAKtJREFUeNpNiotyAUEQRc%2FMsISERYJ4r%2Fci3rtD%2F%2F%2BH6dol5VTXrT63LmCcRqOh4QyKhfLvcr9f9soq2c2OknGa500skibeJ6lIrM5CEi8ZPpEFVM%2B3qxeviL%2Fez1XGoqSiZLsR29Nk8CeHKDrIrj%2B9bPj%2BABMFYRhEBr5%2BgGJRYzh8fdbqokS7Tcnkpm4d3Q4FnhgI3gtLpQat3lvxuXas6jj%2Bm2YcjzC5PQDI%2BhSeN0pHJAAAAABJRU5ErkJggg%3D%3D)](https://codecov.io/gh/Marwan-Al-Masri/LOC8)

Development | Production
---|---
![graph](https://codecov.io/gh/Marwan-Al-Masri/LOC8/branch/development/graphs/sunburst.svg?token=g1kcxuoSG6) | ![graph](https://codecov.io/gh/Marwan-Al-Masri/LOC8/branch/master/graphs/sunburst.svg?token=g1kcxuoSG6) -->

# LOC8

 LOC8 is a mobile application project that detect a human motion in three dimensions.

## Requirements

- macOS 10.13 and above

- Xcode 9.0 and above

- [SwiftLint](https://github.com/realm/SwiftLint)

>_Insure swift style and_

- [Jazzy](https://github.com/realm/jazzy)

>_Generates project documentation_


## Get Started


```bash
# install [SwiftLint
brew install swiftlint

# install Jazzy
gem install jazzy # you may need sudo
```

before you start you should read the [project fundamentals](Documentation/Fundamentals.md)

## Documentation

you can access the project documentation [here](https://marwan-al-masri.github.io/LOC8/index.html). before releasing make sure to generate the project documentation.

to generate documentation run `jazzy` in the terminal.

## Contributing
If you are new to this repository, please read [development doc](Documentation/Development.md) first.

## License
LOC8 Sdn Bhd
