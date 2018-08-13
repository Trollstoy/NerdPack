#!/usr/bin/env bash

# Modify the two vars so it match you own setup. Make sure you have it surrounded by double quotes
# WoWRep  : World of warcraft main directory
# GHRep   : Where your github projects are stored (by default in Documents/GitHub)
WoWRep="/Applications/World of Warcraft"
GHRep=$(pwd)

ln -s "$GHRep" "$WoWRep/Interface/AddOns/NerdPack"
