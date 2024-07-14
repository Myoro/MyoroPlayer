#!/bin/bash
# Run this within the MyoroPlayer/frontend directory
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html