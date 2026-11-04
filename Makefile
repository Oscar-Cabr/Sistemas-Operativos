FILE    = 02_Memoria_y_Procesos
OUTPUT  = ENTREGABLES/TAREAS/T$(FILE)_CabreraRojasOscar
OUTDIR  = build
TYPE    = $(notdir $(patsubst %/,%,$(dir $(OUTPUT))))
SRC     = $(TYPE)/$(FILE).tex
PDF     = $(OUTPUT).pdf
VIEWER  = zathura
REPORT  = compile-report.txt
NOTIFY  = $(HOME)/.config/sh-scripts/latex-compile-notify.sh

LATEXMK_FLAGS = -pdf -interaction=nonstopmode -file-line-error -outdir=$(OUTDIR)

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
	@status=0; latexmk $(LATEXMK_FLAGS) $(SRC) || status=$$?; \
	$(NOTIFY) $(OUTDIR)/$(FILE).log $(REPORT) || true; \
	exit $$status
	cp $(OUTDIR)/$(FILE).pdf $(PDF)

view: pdf
	@pgrep -xa $(VIEWER) | grep -q "$(FILE).pdf" || setsid -f $(VIEWER) $(PDF) >/dev/null 2>&1

report:
	@$(NOTIFY) $(OUTDIR)/$(FILE).log $(REPORT) || true

rawlog:
	less $(OUTDIR)/$(FILE).log

lint: check
	-chktex $(SRC)

clean:
	@case "$(OUTDIR)" in ENTREGABLES*|.|./|"") echo "OUTDIR inválido para limpiar: '$(OUTDIR)'" >&2; exit 2 ;; esac
	-latexmk -C -outdir=$(OUTDIR) $(SRC)
	rm -rf $(OUTDIR) $(REPORT)

.PHONY: all check pdf view report rawlog lint clean
