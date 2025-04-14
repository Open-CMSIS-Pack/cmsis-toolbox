#include "Hidden.h"
#include "Private.h"
#include "Visible.h"

#ifndef HIDDEN_H
#error "HIDDEN_H is not defined"
#endif

#ifndef PRIVATE_H
#error "PRIVATE_H is not defined"
#endif

#ifndef VISIBLE_H
#error "VISIBLE_H is not defined"
#endif

#if __has_include("Public.h")
#include "Public.h"
#endif
#ifdef PUBLIC_H
#error "PUBLIC_H is defined"
#endif

int Dummy2(int i) {
    return 1;
}
