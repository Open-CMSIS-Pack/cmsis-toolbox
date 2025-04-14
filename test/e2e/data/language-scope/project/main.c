#include "RTE_Components.h"
#include CMSIS_device_header

#if __has_include("Hidden.h")
#include "Hidden.h"
#endif
#ifdef HIDDEN_H
#error "HIDDEN_H is defined"
#endif

#if __has_include("Private.h")
#include "Private.h"
#endif
#ifdef PRIVATE_H
#error "PRIVATE_H is defined"
#endif

#if __has_include("Public.h")
#include "Public.h"
#endif
#ifndef PUBLIC_H
#error "PUBLIC_H is not defined"
#endif

#if __has_include("Visible.h")
#include "Visible.h"
#endif
#ifndef VISIBLE_H
#error "VISIBLE_H is not defined"
#endif

int main(void) {
  return 0;
}
