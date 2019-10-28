REF_FILE=usage_test/archive.ref
RULES_ARCHIVE=bazel-bin/archive.tar.gz

.PHONY: test
test: $(REF_FILE)
	[ "`$(MAKE) -s --no-print-directory run`" == "Hello world!" ]

.PHONY: test
test.str: $(REF_FILE)
	[ "`$(MAKE) -s --no-print-directory run.str`" == "Hello world!" ]

.PHONY: release
release: $(RULES_ARCHIVE)

.PHONY: $(RULES_ARCHIVE)
$(RULES_ARCHIVE):
	bazel build archive

.PHONY: run
run:
	cd usage_test && bazel run @hello_ipfs//:hello_world

.PHONY: run
run.str:
	cd usage_test && bazel run @hello_ipfs_str_ref//:hello_world

.PHONY: ipfs_init
ipfs_init:
	cd usage_test && bazel run @bazel_ipfs_tools//:ipfs -- init

.PHONY: $(REF_FILE)
$(REF_FILE):
	cd hello_bazel && bazel run pin > ../$@

.PHONY: re
clean:
	rm -f $(REF_FILE)
	cd hello_bazel && bazel clean --expunge
	cd usage_test && bazel clean --expunge
	bazel clean --expunge

.PHONY: re
re: clean
	$(MAKE)
