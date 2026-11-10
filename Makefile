# ==============================================================================
# Variables de cabecera / Flags de compilación
# ==============================================================================
FILE          ?= 05_Windows_Server_IIS
OUTPUT        ?= ENTREGABLES/PROYECTOS/P05_Windows_Server_IIS_CabreraRojasOscar
OUTDIR        ?= build
VIEWER        ?= zathura
NOTIFY        ?= $(HOME)/.config/sh-scripts/latex-compile-notify.sh
EXTRA_FLAGS   ?=

# Si se suministra SRC directamente, deducir FILE y TYPE
ifneq ($(origin SRC), undefined)
  override FILE := $(basename $(notdir $(SRC)))
  override TYPE := $(firstword $(subst /, ,$(SRC)))
endif

# Normalizar FILE sin extensión .tex
override FILE := $(patsubst %.tex,%,$(FILE))

# Deducir TYPE (TAREAS o PROYECTOS) si no se especificó
ifeq ($(origin TYPE), undefined)
  ifneq ($(wildcard TAREAS/$(FILE).tex),)
    TYPE = TAREAS
  else ifneq ($(wildcard PROYECTOS/$(FILE).tex),)
    TYPE = PROYECTOS
  else ifneq ($(OUTPUT),)
    TYPE = $(notdir $(patsubst %/,%,$(dir $(OUTPUT))))
  else
    TYPE = TAREAS
  endif
endif

SRC ?= $(TYPE)/$(FILE).tex

# Deducir prefijo y ruta de OUTPUT según normativa GEMINI.md
ifeq ($(TYPE),PROYECTOS)
  _LETTER = P
else
  _LETTER = T
endif

_IS_NUM = $(filter 0% 1% 2% 3% 4% 5% 6% 7% 8% 9%,$(FILE))

ifeq ($(_IS_NUM),)
  _PREFIX = $(_LETTER)_
else
  _PREFIX = $(_LETTER)
endif

ifeq ($(OUTPUT),)
  OUTPUT = ENTREGABLES/$(TYPE)/$(_PREFIX)$(FILE)_CabreraRojasOscar
endif

PDF     ?= $(OUTPUT).pdf
REPORT  ?= $(if $(filter 03_Atajos_Vi_y_Comandos,$(FILE)),compile-report.txt,compile-report-$(FILE).txt)

LATEXMK_FLAGS ?= -pdf -interaction=nonstopmode -file-line-error -outdir=$(OUTDIR)

all: pdf view

check:
	@case "$(dir $(OUTPUT))" in \
	  ENTREGABLES/TAREAS/|ENTREGABLES/PROYECTOS/) ;; \
	  *) echo "OUTPUT debe ser ENTREGABLES/TAREAS/... o ENTREGABLES/PROYECTOS/...; vale '$(OUTPUT)'" >&2; exit 2 ;; \
	esac
	@case "$(notdir $(OUTPUT))" in \
	  T*$(FILE)_CabreraRojasOscar|P*$(FILE)_CabreraRojasOscar|$(FILE)) ;; \
	  *) echo "OUTPUT debe coincidir con T\$$(FILE)_CabreraRojasOscar o P\$$(FILE)_CabreraRojasOscar: '$(OUTPUT)'" >&2; exit 2 ;; \
	esac
	@test -f "$(SRC)" || { echo "No existe $(SRC)" >&2; exit 2; }

pdf: check
	mkdir -p $(OUTDIR) $(dir $(PDF))
	@status=0; latexmk $(LATEXMK_FLAGS) $(EXTRA_FLAGS) $(SRC) || status=$$?; \
	$(NOTIFY) $(OUTDIR)/$(FILE).log $(REPORT) || true; \
	if [ "$(REPORT)" != "compile-report.txt" ]; then cp "$(REPORT)" compile-report.txt 2>/dev/null || true; fi; \
	exit $$status
	cp $(OUTDIR)/$(FILE).pdf $(PDF)

view: pdf
	@pgrep -xa $(VIEWER) | grep -q "$(notdir $(PDF))" || setsid -f $(VIEWER) $(PDF) >/dev/null 2>&1

report:
	@$(NOTIFY) $(OUTDIR)/$(FILE).log $(REPORT) || true
	@if [ "$(REPORT)" != "compile-report.txt" ]; then cp "$(REPORT)" compile-report.txt 2>/dev/null || true; fi

rawlog:
	less $(OUTDIR)/$(FILE).log

lint: check
	-chktex $(SRC)

clean:
	@case "$(OUTDIR)" in ENTREGABLES*|.|./|"") echo "OUTDIR inválido para limpiar: '$(OUTDIR)'" >&2; exit 2 ;; esac
	-latexmk -C -outdir=$(OUTDIR) $(SRC)
	rm -f $(OUTDIR)/$(FILE).* $(REPORT) compile-report.txt
	@rmdir $(OUTDIR) 2>/dev/null || true

clean-all:
	@case "$(OUTDIR)" in ENTREGABLES*|.|./|"") echo "OUTDIR inválido para limpiar: '$(OUTDIR)'" >&2; exit 2 ;; esac
	rm -rf $(OUTDIR) compile-report*.txt

.PHONY: all check pdf view report rawlog lint clean clean-all
